import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/arguments/arguments.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/ui/views/views.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.welcome:
        return MaterialPageRoute<WelcomeView>(builder: (_) => WelcomeView());
      case RoutePaths.login:
        return MaterialPageRoute<LoginView>(builder: (_) => LoginView());
      case RoutePaths.forgotPassword:
        return MaterialPageRoute<ForgotPasswordView>(
            builder: (_) => ForgotPasswordView());
      case RoutePaths.signUp:
        return MaterialPageRoute<SignUpView>(builder: (_) => SignUpView());
      case RoutePaths.tabs:
        return MaterialPageRoute<TabsView>(builder: (_) => TabsView());
      case RoutePaths.account:
        return MaterialPageRoute<AccountView>(builder: (_) => AccountView());
      case RoutePaths.support:
        return MaterialPageRoute<SupportView>(builder: (_) => SupportView());
      case RoutePaths.network:
        return MaterialPageRoute<NetworkView>(builder: (_) => NetworkView());
      case RoutePaths.networkContacts:
        return MaterialPageRoute<ContactsView>(builder: (_) => ContactsView());
      case RoutePaths.networkFindTeam:
        return MaterialPageRoute<FindTeamView>(builder: (_) => FindTeamView());
      case RoutePaths.networkEvents:
        return MaterialPageRoute<EventsView>(builder: (_) => EventsView());
      case RoutePaths.myEventListings:
        return MaterialPageRoute<MyEventListingsView>(builder: (_) => MyEventListingsView());
      case RoutePaths.editEvent:
        final event = settings.arguments as Event;
        return MaterialPageRoute<EditEventView>(builder: (_) => EditEventView(event: event));
      case RoutePaths.addContact:
        return MaterialPageRoute<AddContactView>(
            builder: (_) => AddContactView());
      case RoutePaths.networkAssociations:
        return MaterialPageRoute<AssociationsView>(
            builder: (_) => AssociationsView());
      case RoutePaths.eiaBasics:
        return MaterialPageRoute<EIABasicsView>(
            builder: (_) => EIABasicsView());
      case RoutePaths.checkRegs:
        return MaterialPageRoute<CheckRegsView>(
            builder: (_) => CheckRegsView());
      case RoutePaths.waterUses:
        return MaterialPageRoute<WaterUsesView>(
            builder: (_) => WaterUsesView());
      case RoutePaths.nwaRegs:
        return MaterialPageRoute<NWARegsView>(builder: (_) => NWARegsView());
      case RoutePaths.nemaApplications:
        return MaterialPageRoute<NEMAApplicationsView>(
            builder: (_) => NEMAApplicationsView());
      case RoutePaths.basicAssessment:
        return MaterialPageRoute<BasicAssessmentView>(
            builder: (_) => BasicAssessmentView());
      case RoutePaths.scopingEIR:
        return MaterialPageRoute<ScopingEIRView>(
            builder: (_) => ScopingEIRView());
      case RoutePaths.section24G:
        return MaterialPageRoute<Section24GView>(
            builder: (_) => Section24GView());
      case RoutePaths.eaAmendment:
        return MaterialPageRoute<EAAmendmentView>(
            builder: (_) => EAAmendmentView());
      case RoutePaths.acronyms:
        return MaterialPageRoute<AcronymsView>(builder: (_) => AcronymsView());
      case RoutePaths.definitions:
        return MaterialPageRoute<DefinitionsView>(
            builder: (_) => DefinitionsView());
      case RoutePaths.nfaTrees:
        return MaterialPageRoute<NFATreesView>(builder: (_) => NFATreesView());
      case RoutePaths.nemaActivities:
        return MaterialPageRoute<NEMAActivitiesView>(
            builder: (_) => NEMAActivitiesView());
      case RoutePaths.nemaActivityDetails:
        final activity = settings.arguments as NEMAActivity;
        return MaterialPageRoute<NEMAActivityDetailsView>(
          builder: (_) => NEMAActivityDetailsView(activity: activity),
        );
      case RoutePaths.adverts:
        return MaterialPageRoute<AdvertsView>(builder: (_) => AdvertsView());
      case RoutePaths.advertDetails:
        final advert = settings.arguments as Advert;
        return MaterialPageRoute<AdvertDetailsView>(
          builder: (_) => AdvertDetailsView(advert: advert),
        );
      case RoutePaths.createAdvert:
        return MaterialPageRoute<CreateAdvertView>(
          builder: (_) => CreateAdvertView(),
        );
      case RoutePaths.events:
        return MaterialPageRoute<EventsView>(builder: (_) => EventsView());
      case RoutePaths.eventDetails:
        final event = settings.arguments as Event;
        return MaterialPageRoute<EventDetailsView>(
          builder: (_) => EventDetailsView(event: event),
        );
      case RoutePaths.createEvent:
        return MaterialPageRoute<CreateEventView>(
          builder: (_) => CreateEventView(),
        );
      case RoutePaths.lawHubs:
        return MaterialPageRoute<LawHubsView>(builder: (_) => LawHubsView());
      case RoutePaths.updateProfileDetails:
        return MaterialPageRoute<UpdateProfileDetailsView>(
            builder: (_) => UpdateProfileDetailsView(
                  arguments:
                      settings.arguments as UpdateProfileDetailsArguments,
                ));
      default:
        return null;
    }
  }
}
