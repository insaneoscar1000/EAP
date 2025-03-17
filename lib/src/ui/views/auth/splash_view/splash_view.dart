import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class SplashView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(),
        onViewModelReady: (SplashViewModel model) =>
            model.initialiseApplication(),
        builder: (BuildContext context, SplashViewModel model, Widget? child) =>
            Scaffold(
              backgroundColor: Colors.white,
              body: BackgroundContainer(
                background: 'background-1',
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                      ),
                      SizedBox(height: 24),
                      Text(
                        'The EAP App',
                        style: TextStyle(
                          fontSize: 44,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
