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
                    ],
                  ),
                ),
              ),
            ));
  }
}
