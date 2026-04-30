import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/arguments/arguments.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/models/models.dart';
import 'package:the_eap_app/src/ui/views/views.dart';
import 'package:the_eap_app/src/ui/views/projects/iap_database_view/add_iap_entry_view.dart';

import 'package:the_eap_app/src/ui/landing_page.dart';

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
      case RoutePaths.home:
        return MaterialPageRoute<HomeView>(builder: (_) => HomeView());
      case '/landing':
        return MaterialPageRoute<LandingPage>(builder: (_) => LandingPage());
      case RoutePaths.account:
        return MaterialPageRoute<AccountView>(builder: (_) => AccountView());
      case RoutePaths.projects:
        return MaterialPageRoute<ProjectsView>(builder: (_) => ProjectsView());
      case RoutePaths.archivedProjects:
        return MaterialPageRoute<ArchivedProjectsView>(
            builder: (_) => ArchivedProjectsView());
      case RoutePaths.createProject:
        final String? projectId = settings.arguments as String?;
        return MaterialPageRoute<CreateProjectView>(
            builder: (_) => CreateProjectView(projectId: projectId));
      case RoutePaths.projectDetails:
        final Project project = settings.arguments as Project;
        return MaterialPageRoute<ProjectDetailsView>(
            builder: (_) => ProjectDetailsView(project: project));
      case RoutePaths.iapDatabase:
        final String projectId = settings.arguments as String;
        return MaterialPageRoute<IAPDatabaseView>(
            builder: (_) => IAPDatabaseView(projectId: projectId));
      case RoutePaths.addIapEntry:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute<AddIAPEntryView>(
          builder: (_) => AddIAPEntryView(
            projectId: args['projectId'] as String,
            projectName: args['projectName'] as String,
          ),
        );
      case RoutePaths.editIapEntry:
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute<AddIAPEntryView>(
          builder: (_) => AddIAPEntryView(
            projectId: args['projectId'] as String,
            projectName: args['projectName'] as String,
            iap: args['iap'] as IAP,
          ),
        );
      case RoutePaths.schedule:
        return MaterialPageRoute<ScheduleView>(builder: (_) => ScheduleView());
      case RoutePaths.createToDo:
        return MaterialPageRoute<CreateToDoView>(
            builder: (_) => CreateToDoView());
      case RoutePaths.editToDo:
        final Task task = settings.arguments as Task;
        return MaterialPageRoute<CreateToDoView>(
            builder: (_) => CreateToDoView(task: task));
      case RoutePaths.myToDoList:
        return MaterialPageRoute<MyToDoListView>(
            builder: (_) => MyToDoListView());
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
        return MaterialPageRoute<MyEventListingsView>(
            builder: (_) => MyEventListingsView());
      case RoutePaths.editEvent:
        final Event event = settings.arguments as Event;
        return MaterialPageRoute<EditEventView>(
            builder: (_) => EditEventView(event: event));
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
        final NEMAActivity activity = settings.arguments as NEMAActivity;
        return MaterialPageRoute<NEMAActivityDetailsView>(
          builder: (_) => NEMAActivityDetailsView(activity: activity),
        );
      case RoutePaths.adverts:
        return MaterialPageRoute<AdvertsView>(builder: (_) => AdvertsView());
      case RoutePaths.advertDetails:
        final Advert advert = settings.arguments as Advert;
        return MaterialPageRoute<AdvertDetailsView>(
          builder: (_) => AdvertDetailsView(advert: advert),
        );
      case RoutePaths.createAdvert:
        return MaterialPageRoute<CreateAdvertView>(
          builder: (_) => CreateAdvertView(),
        );
      // Events case is handled in the networkEvents case above
      case RoutePaths.eventDetails:
        final Event event = settings.arguments as Event;
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
      case RoutePaths.subscription:
        return MaterialPageRoute<SubscriptionView>(
            builder: (_) => const SubscriptionView());
      default:
        return null;
    }
  }
}
