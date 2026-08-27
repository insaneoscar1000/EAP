import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:the_eap_app/src/locator.dart';
import 'package:the_eap_app/src/core/services/services.dart';
import 'package:the_eap_app/src/ui/router.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/views/views.dart';
import 'package:the_eap_app/src/ui/managers/dialog_manager.dart';
import 'package:the_eap_app/src/ui/shared/responsive_scaffold.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return OverlaySupport(
      child: MaterialApp(
        title: 'The EAP App',
        debugShowCheckedModeBanner: false,
        navigatorKey: locator<NavigationService>().navigationKey,
        onGenerateRoute: AppRouter.generateRoute,
        // Automatic screen-view tracking, per Sandy's approved analytics setup (2026-08-27):
        // FirebaseAnalyticsObserver reads each pushed route's RouteSettings.name (already set
        // on every named route in router.dart) with no per-screen wiring needed.
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        theme: AppTheme.themeData,
        builder: (context, child) => ResponsiveScaffold(
          child: DialogManager(
            child: child ?? Container(),
          ),
        ),
        home: SplashView(),
      ),
    );
  }
}
