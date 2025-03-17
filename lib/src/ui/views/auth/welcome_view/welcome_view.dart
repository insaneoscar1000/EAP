import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BackgroundContainer(
            background: 'background-1',
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  Image.asset('assets/images/logo.png', height: 150),
                  SizedBox(height: 24),
                  _buildHeader(),
                  SizedBox(height: 48),
                  _buildButtons(context)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome to the EAP App!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, RoutePaths.login),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(double.infinity, 50),
            backgroundColor: AppTheme.themeData.primaryColor,
          ),
          child: Text(
            'Login',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, RoutePaths.signUp),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(vertical: 16),
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Color(0xff608E72),
          ),
          child: Text(
            'Sign Up',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        )
      ],
    );
  }
}
