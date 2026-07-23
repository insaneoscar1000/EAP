/**
 * PayStack integration for The EAP App.
 *
 * Three entry points:
 *   - `initializeSubscription`  callable — starts a recurring subscription
 *                               checkout (web build only).
 *   - `initializeAdPayment`     callable — starts a one-off ad placement
 *                               checkout.
 *   - `paystackWebhook`         HTTP — receives PayStack events, verifies
 *                               the signature, updates Firestore.
 *
 * The PayStack secret key is stored as a Firebase secret. Set it once:
 *   firebase functions:secrets:set PAYSTACK_SECRET_KEY
 *
 * Then deploy. The secret never lives in the client.
 */

import * as crypto from 'crypto';
import axios from 'axios';
import {initializeApp} from 'firebase-admin/app';
import {getFirestore, FieldValue, Timestamp} from 'firebase-admin/firestore';
import {
  onCall,
  HttpsError,
  CallableRequest,
} from 'firebase-functions/v2/https';
import {onRequest} from 'firebase-functions/v2/https';
import {defineSecret} from 'firebase-functions/params';
import {logger} from 'firebase-functions/v2';

initializeApp();

const paystackSecret = defineSecret('PAYSTACK_SECRET_KEY');

// Firebase Hosting auto-provisions `https://<project-id>.web.app` until a
// custom domain is connected. Update when the production domain is live.
const WEB_BASE_URL = 'https://the-eap-app.web.app';
const PAYSTACK_BASE = 'https://api.paystack.co';

// ---------------------------------------------------------------------------
// Callable: initialize subscription
// ---------------------------------------------------------------------------

export const initializeSubscription = onCall(
  {secrets: [paystackSecret]},
  async (req: CallableRequest<{planCode: string; email: string}>) => {
    if (!req.auth) {
      throw new HttpsError('unauthenticated', 'Login required.');
    }
    const {planCode, email} = req.data;
    if (!planCode || !email) {
      throw new HttpsError('invalid-argument', 'planCode and email required.');
    }

    // PayStack's `/transaction/initialize` requires `amount` even when
    // `plan` is set — and it must match the plan's price. Look up the
    // plan to avoid hard-coding (and drifting from) its price here.
    const planResp = await axios.get(
      `${PAYSTACK_BASE}/plan/${planCode}`,
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
        },
      },
    );
    if (!planResp.data?.status) {
      logger.error('PayStack plan lookup failed', planResp.data);
      throw new HttpsError('internal', 'Could not load subscription plan.');
    }
    const planAmount = planResp.data.data.amount as number;

    const reference = `sub_${req.auth.uid}_${Date.now()}`;
    const {data} = await axios.post(
      `${PAYSTACK_BASE}/transaction/initialize`,
      {
        email,
        plan: planCode,
        amount: planAmount,
        reference,
        callback_url: `${WEB_BASE_URL}/subscription/return`,
        metadata: {
          uid: req.auth.uid,
          purpose: 'subscription',
        },
      },
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
          'Content-Type': 'application/json',
        },
      },
    );

    if (!data?.status) {
      logger.error('PayStack initialize failed', data);
      throw new HttpsError('internal', 'PayStack initialize failed.');
    }

    return {
      authorizationUrl: data.data.authorization_url as string,
      reference: data.data.reference as string,
    };
  },
);

// ---------------------------------------------------------------------------
// Callable: cancel subscription
// ---------------------------------------------------------------------------
//
// PayStack `/subscription/disable` stops future renewals; the current
// period stays active until the end-date already recorded on the
// subscription. The webhook (`subscription.disable` /
// `subscription.not_renew`) is what ultimately flips Firestore — but we
// also write `status: 'cancelled'` here so the user sees the change
// immediately rather than waiting for the async webhook.

export const cancelSubscription = onCall(
  {secrets: [paystackSecret]},
  async (req: CallableRequest<Record<string, never>>) => {
    if (!req.auth) {
      throw new HttpsError('unauthenticated', 'Login required.');
    }

    const uid = req.auth.uid;
    const userDoc = await getFirestore().collection('users').doc(uid).get();
    const sub = userDoc.data()?.subscription as
      | {subscriptionCode?: string; status?: string}
      | undefined;
    const subscriptionCode = sub?.subscriptionCode;
    if (!subscriptionCode) {
      throw new HttpsError(
        'failed-precondition',
        'No active subscription to cancel.',
      );
    }

    // PayStack requires (code, token) to disable a subscription. The
    // email token isn't always captured at creation time, so fetch the
    // subscription record from PayStack to get it.
    const detailResp = await axios.get(
      `${PAYSTACK_BASE}/subscription/${subscriptionCode}`,
      {
        headers: {Authorization: `Bearer ${paystackSecret.value()}`},
      },
    );
    if (!detailResp.data?.status) {
      logger.error('PayStack subscription lookup failed', detailResp.data);
      throw new HttpsError('internal', 'Could not load subscription details.');
    }
    const emailToken = detailResp.data.data.email_token as string;

    const disableResp = await axios.post(
      `${PAYSTACK_BASE}/subscription/disable`,
      {code: subscriptionCode, token: emailToken},
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
          'Content-Type': 'application/json',
        },
      },
    );
    if (!disableResp.data?.status) {
      logger.error('PayStack subscription disable failed', disableResp.data);
      throw new HttpsError('internal', 'Could not cancel subscription.');
    }

    // Write through immediately so the UI updates without waiting for the
    // PayStack webhook to arrive. `currentPeriodEnd` is preserved so the
    // user keeps access until the end of the billing period.
    await getFirestore().collection('users').doc(uid).set(
      {
        subscription: {
          status: 'cancelled',
          cancelledAt: FieldValue.serverTimestamp(),
          updatedAt: FieldValue.serverTimestamp(),
        },
      },
      {merge: true},
    );

    return {status: 'cancelled'};
  },
);

// ---------------------------------------------------------------------------
// Callable: initialize ad payment
// ---------------------------------------------------------------------------

export const initializeAdPayment = onCall(
  {secrets: [paystackSecret]},
  async (
    req: CallableRequest<{advertId: string; amount: number; email: string}>,
  ) => {
    if (!req.auth) {
      throw new HttpsError('unauthenticated', 'Login required.');
    }
    const {advertId, amount, email} = req.data;
    if (!advertId || !amount || !email) {
      throw new HttpsError(
        'invalid-argument',
        'advertId, amount and email required.',
      );
    }

    const reference = `ad_${advertId}_${Date.now()}`;
    const {data} = await axios.post(
      `${PAYSTACK_BASE}/transaction/initialize`,
      {
        email,
        // PayStack expects the amount in the lowest denomination
        // (kobo / cents) — multiply major-unit currency by 100.
        amount: Math.round(amount * 100),
        reference,
        callback_url: `${WEB_BASE_URL}/adverts/return`,
        metadata: {
          uid: req.auth.uid,
          advertId,
          purpose: 'ad',
        },
      },
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
          'Content-Type': 'application/json',
        },
      },
    );

    if (!data?.status) {
      logger.error('PayStack ad initialize failed', data);
      throw new HttpsError('internal', 'PayStack initialize failed.');
    }

    return {
      authorizationUrl: data.data.authorization_url as string,
      reference: data.data.reference as string,
    };
  },
);

// ---------------------------------------------------------------------------
// Callable: initialize event payment
// ---------------------------------------------------------------------------

export const initializeEventPayment = onCall(
  {secrets: [paystackSecret]},
  async (
    req: CallableRequest<{eventId: string; amount: number; email: string}>,
  ) => {
    if (!req.auth) {
      throw new HttpsError('unauthenticated', 'Login required.');
    }
    const {eventId, amount, email} = req.data;
    if (!eventId || !amount || !email) {
      throw new HttpsError(
        'invalid-argument',
        'eventId, amount and email required.',
      );
    }

    const reference = `event_${eventId}_${Date.now()}`;
    const {data} = await axios.post(
      `${PAYSTACK_BASE}/transaction/initialize`,
      {
        email,
        amount: Math.round(amount * 100),
        reference,
        callback_url: `${WEB_BASE_URL}/events/return`,
        metadata: {
          uid: req.auth.uid,
          eventId,
          purpose: 'event',
        },
      },
      {
        headers: {
          Authorization: `Bearer ${paystackSecret.value()}`,
          'Content-Type': 'application/json',
        },
      },
    );

    if (!data?.status) {
      logger.error('PayStack event initialize failed', data);
      throw new HttpsError('internal', 'PayStack initialize failed.');
    }

    return {
      authorizationUrl: data.data.authorization_url as string,
      reference: data.data.reference as string,
    };
  },
);

// ---------------------------------------------------------------------------
// HTTP webhook: paystackWebhook
// ---------------------------------------------------------------------------

export const paystackWebhook = onRequest(
  {secrets: [paystackSecret]},
  async (req, res) => {
    // Verify signature. PayStack signs the raw body with HMAC-SHA512
    // using the secret key.
    const signature = req.header('x-paystack-signature');
    const expected = crypto
      .createHmac('sha512', paystackSecret.value())
      .update(JSON.stringify(req.body))
      .digest('hex');

    if (signature !== expected) {
      logger.warn('PayStack webhook signature mismatch');
      res.status(401).send('Invalid signature');
      return;
    }

    const event = req.body?.event as string | undefined;
    const data = req.body?.data;

    try {
      switch (event) {
        case 'charge.success':
          await handleChargeSuccess(data);
          break;
        case 'subscription.create':
        case 'subscription.enable':
          await handleSubscriptionActive(data);
          break;
        case 'subscription.disable':
        case 'subscription.not_renew':
          await handleSubscriptionInactive(data);
          break;
        case 'invoice.payment_failed':
          await handlePaymentFailed(data);
          break;
        default:
          logger.info('Unhandled PayStack event', {event});
      }
      res.status(200).send('ok');
    } catch (e) {
      logger.error('Webhook handler error', e);
      res.status(500).send('Handler error');
    }
  },
);

// ---------------------------------------------------------------------------
// Handlers
// ---------------------------------------------------------------------------

async function handleChargeSuccess(data: any): Promise<void> {
  const purpose = data?.metadata?.purpose as string | undefined;
  const uid = data?.metadata?.uid as string | undefined;
  if (!uid) {
    logger.warn('charge.success without uid metadata', {reference: data?.reference});
    return;
  }

  if (purpose === 'ad') {
    const advertId = data?.metadata?.advertId as string | undefined;
    if (!advertId) return;
    await getFirestore().collection('adverts').doc(advertId).set(
      {
        status: 'Approved',
        payment: {
          status: 'paid',
          reference: data.reference,
          paidAt: Timestamp.now(),
          amount: data.amount / 100,
          currency: data.currency,
        },
      },
      {merge: true},
    );
    return;
  }

  if (purpose === 'event') {
    const eventId = data?.metadata?.eventId as string | undefined;
    if (!eventId) return;
    await getFirestore().collection('events').doc(eventId).set(
      {
        status: 'Approved',
        payment: {
          status: 'paid',
          reference: data.reference,
          paidAt: Timestamp.now(),
          amount: data.amount / 100,
          currency: data.currency,
        },
      },
      {merge: true},
    );
    return;
  }

  if (purpose === 'subscription') {
    // First charge of a new subscription — record the entitlement.
    // `subscription.create` will follow with the canonical period end.
    await getFirestore().collection('users').doc(uid).set(
      {
        subscription: {
          status: 'active',
          plan: data?.plan?.plan_code ?? null,
          lastPaymentRef: data.reference,
          updatedAt: FieldValue.serverTimestamp(),
        },
      },
      {merge: true},
    );
  }
}

async function handleSubscriptionActive(data: any): Promise<void> {
  // PayStack subscription payloads contain `customer.email` and
  // (sometimes) `metadata`. We resolve uid by querying users collection
  // by email, since `subscription.create` doesn't always carry uid.
  const customerEmail = data?.customer?.email as string | undefined;
  const planCode = data?.plan?.plan_code as string | undefined;
  const nextPaymentDate = data?.next_payment_date as string | undefined;
  if (!customerEmail) return;

  const uid = await uidForEmail(customerEmail);
  if (!uid) {
    logger.warn('No user matched email', {customerEmail});
    return;
  }

  await getFirestore().collection('users').doc(uid).set(
    {
      subscription: {
        status: 'active',
        plan: planCode ?? null,
        currentPeriodEnd: nextPaymentDate
          ? Timestamp.fromDate(new Date(nextPaymentDate))
          : null,
        subscriptionCode: data?.subscription_code ?? null,
        updatedAt: FieldValue.serverTimestamp(),
      },
    },
    {merge: true},
  );
}

async function handleSubscriptionInactive(data: any): Promise<void> {
  const customerEmail = data?.customer?.email as string | undefined;
  if (!customerEmail) return;
  const uid = await uidForEmail(customerEmail);
  if (!uid) return;

  await getFirestore().collection('users').doc(uid).set(
    {
      subscription: {
        status: 'cancelled',
        updatedAt: FieldValue.serverTimestamp(),
      },
    },
    {merge: true},
  );
}

async function handlePaymentFailed(data: any): Promise<void> {
  const customerEmail = data?.customer?.email as string | undefined;
  if (!customerEmail) return;
  const uid = await uidForEmail(customerEmail);
  if (!uid) return;

  await getFirestore().collection('users').doc(uid).set(
    {
      subscription: {
        status: 'expired',
        updatedAt: FieldValue.serverTimestamp(),
      },
    },
    {merge: true},
  );
}

async function uidForEmail(email: string): Promise<string | null> {
  const snap = await getFirestore()
    .collection('users')
    .where('contact.emailAddress', '==', email)
    .limit(1)
    .get();
  if (snap.empty) return null;
  return snap.docs[0].id;
}
