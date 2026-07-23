import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_eap_app/src/core/constants/service_constants.dart';

class MailService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> sendEventCreationEmail(String eventName, String organization,
      String creatorName, String creatorEmail) async {
    try {
      Map<String, dynamic> doc = <String, dynamic>{
        'message': <String, String>{
          'subject': 'New Event Created: $eventName',
          'text': 'New Event Created: $eventName',
          'html': '''
<!doctype html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Event Created</title>
    <style>
        body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
        table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
        img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
        table { border-collapse: collapse !important; }
        body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; font-size: inherit !important; font-family: inherit !important; font-weight: inherit !important; line-height: inherit !important; }
    </style>
</head>
<body style="margin: 0 !important; padding: 0 !important; background: #fff">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td bgcolor="#0F6358" align="center" style="padding: 10px 15px 30px 15px">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px">
                    <tr>
                        <td align="center" style="font-size: 25px; font-family: Urbanist, Helvetica, Arial, sans-serif; color: #ffffff; padding-top: 30px;">New Event Created!</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#ffffff" align="center" style="padding: 25px 15px 70px 15px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px;">
                    <tr>
                        <td style="padding: 0 0 20px 0; font-size: 16px; line-height: 25px; color: #232323;">
                            <h2 style="font-size: 20px; font-weight: 400; color: #232323; margin: 0;">Dear $creatorName,</h2>
                            <p style="margin: 20px 0;">Thank you for creating a new event on the EAP App. Your event "$eventName" for $organization has been submitted successfully.</p>
                            
                            <p style="margin: 20px 0;">Your event is currently under review by our administrators. Once approved, it will be visible to all users of the application.</p>
                            
                            <p style="margin: 20px 0;">If you have any questions or need to make changes to your event, please contact our support team.</p>
                            
                            <p style="margin: 20px 0;">Thank you for contributing to the EAP community!</p>
                            
                            <p style="margin: 20px 0;">The EAP App Team</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#F4F4F4" align="center" style="padding: 20px 0px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="max-width: 500px;">
                    <tr>
                        <td align="center" style="font-size: 12px; line-height: 18px; font-family: Urbanist, Helvetica, Arial, sans-serif; color:#666666;">
                            The EAP App | Environmental Assessment Practitioners
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>''',
        },
        'to': creatorEmail,
      };

      await _firestore.collection(ServiceConstants.mail).add(doc);
      return true;
    } catch (e) {
      print('Error sending event creation email: $e');
      return false;
    }
  }

  Future<bool> sendAdvertCreationEmail(String advertTitle, String company,
      String creatorName, String creatorEmail) async {
    try {
      Map<String, dynamic> doc = <String, dynamic>{
        'message': <String, String>{
          'subject': 'New Advert Created: $advertTitle',
          'text': 'New Advert Created: $advertTitle',
          'html': '''
<!doctype html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Advert Created</title>
    <style>
        body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
        table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
        img { -ms-interpolation-mode: bicubic; border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
        table { border-collapse: collapse !important; }
        body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; font-size: inherit !important; font-family: inherit !important; font-weight: inherit !important; line-height: inherit !important; }
    </style>
</head>
<body style="margin: 0 !important; padding: 0 !important; background: #fff">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td bgcolor="#E3BD36" align="center" style="padding: 10px 15px 30px 15px">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px">
                    <tr>
                        <td align="center" style="font-size: 25px; font-family: Urbanist, Helvetica, Arial, sans-serif; color: #ffffff; padding-top: 30px;">New Advert Created!</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#ffffff" align="center" style="padding: 25px 15px 70px 15px;">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px;">
                    <tr>
                        <td style="padding: 0 0 20px 0; font-size: 16px; line-height: 25px; color: #232323;">
                            <h2 style="font-size: 20px; font-weight: 400; color: #232323; margin: 0;">Dear $creatorName,</h2>
                            <p style="margin: 20px 0;">Thank you for creating a new advert on the EAP App. Your advert "$advertTitle" for $company has been submitted successfully.</p>
                            
                            <p style="margin: 20px 0;">Your advert is currently under review by our administrators. Once approved, it will be visible to all users of the application.</p>
                            
                            <p style="margin: 20px 0;">If you have any questions or need to make changes to your advert, please contact our support team.</p>
                            
                            <p style="margin: 20px 0;">Thank you for contributing to the EAP community!</p>
                            
                            <p style="margin: 20px 0;">The EAP App Team</p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#F4F4F4" align="center" style="padding: 20px 0px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="max-width: 500px;">
                    <tr>
                        <td align="center" style="font-size: 12px; line-height: 18px; font-family: Urbanist, Helvetica, Arial, sans-serif; color:#666666;">
                            The EAP App | Environmental Assessment Practitioners
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>''',
        },
        'to': creatorEmail,
      };

      await _firestore.collection(ServiceConstants.mail).add(doc);
      return true;
    } catch (e) {
      print('Error sending advert creation email: $e');
      return false;
    }
  }

  Future<bool> sendSupportEmailToAdmins(
      String title, String message, String name, String emailAddress) async {
    try {
      Map<String, dynamic> doc = <String, dynamic>{
        'message': <String, String>{
          'subject': 'New Support Ticket Logged - $name',
          'text': 'New Support Ticket Logged - $name',
          'html': '''
<!doctype html>
<html lang="en-US">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Support Ticket Logged</title>
    <style>
        body, table, td, a { -webkit-text-size-adjust: 100%; -ms-text-size-adjust: 100%; }
        table, td { mso-table-lspace: 0pt; mso-table-rspace: 0pt; }
        img { -ms-interpolation-mode: bicubic; }
        img { border: 0; height: auto; line-height: 100%; outline: none; text-decoration: none; }
        table { border-collapse: collapse !important; }
        body { height: 100% !important; margin: 0 !important; padding: 0 !important; width: 100% !important; }
        a[x-apple-data-detectors] { color: inherit !important; text-decoration: none !important; font-size: inherit !important; font-family: inherit !important; font-weight: inherit !important; line-height: inherit !important; }
        @media screen and (max-width: 525px) {
            .wrapper { width: 100% !important; max-width: 100% !important; }
            .responsive-table { width: 100% !important; }
            .padding { padding: 10px 5% 15px 5% !important; }
            .section-padding { padding: 0 15px 50px 15px !important; }
        }
        .form-container { margin-bottom: 24px; padding: 20px; border: 1px dashed #ccc; }
        .form-heading { color: #2a2a2a; font-family: "Helvetica Neue", "Helvetica", "Arial", sans-serif; font-weight: 400; text-align: left; line-height: 20px; font-size: 18px; margin: 0 0 8px; padding: 0; }
        .form-answer { color: #2a2a2a; font-family: "Helvetica Neue", "Helvetica", "Arial", sans-serif; font-weight: 300; text-align: left; line-height: 20px; font-size: 16px; margin: 0 0 24px; padding: 0; }
        div[style*="margin: 16px 0;"] { margin: 0 !important; }
    </style>
</head>
<body style="margin: 0 !important; padding: 0 !important; background: #fff">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td bgcolor="#FFD340" align="center" style="padding: 10px 15px 30px 15px" class="section-padding">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px" class="responsive-table">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td align="center" style="font-size: 25px; font-family: Helvetica, Arial, sans-serif; color: #ffffff; padding-top: 30px;" class="padding">New Support Ticket Logged</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#ffffff" align="center" style="padding: 25px 15px 70px 15px;" class="section-padding">
                <table border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width: 500px;" class="responsive-table">
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td>
                                        <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                            <tr>
                                                <td style="padding: 0 0 0 0; font-size: 16px; line-height: 25px; color: #232323;" class="padding">
                                                    <h2 style="font-size: 20px; font-weight: 400; color: #232323; margin: 0;">Dear EAP App Team,</h2>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 20px 0 20px 0; font-size: 16px; line-height: 25px; color: #232323;" class="padding">A user has logged a new support ticket.</td>
                                            </tr>
                                            <tr>
                                                <td style="font-family: Arial, sans-serif; color: #333333; font-size: 16px;">$name ($emailAddress)</td>
                                            </tr>
                                           <tr>     
                                                <td style="font-family: Arial, sans-serif; color: #333333; font-size: 16px;">$title</td>
                                            </tr>
                                            <tr>
                                                <td style="padding: 20px 0 20px 0; font-size: 16px; line-height: 25px; color: #232323;" class="padding">$message</td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td bgcolor="#ffffff" align="center" style="padding: 20px 0px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="max-width: 500px;" class="responsive-table">
                    <tr>
                        <td align="center" style="font-size: 12px; line-height: 18px; font-family: Helvetica, Arial, sans-serif; color:#666666;">
                            The EAP App | Environmental Assessment Practitioners
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>''',
        },
        'to': <String?>[
          'sandyvanderwaal@gmail.com',
        ]
      };
      await _firestore.collection(ServiceConstants.mail).add(doc);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
