import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (BuildContext context, LoginViewModel model, Widget? child) {
        void validateForm() {
          if (_formKey.currentState!.validate()) {
            model.login(
              context,
              _emailController.text,
              _passwordController.text,
            );
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              BackgroundContainer(background: 'background-1'),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15),
                      _buildHeader(),
                      SizedBox(height: 48),
                      _buildForm(validateForm, model),
                      _buildFooter(),
                    ],
                  ),
                ),
              ),
              PopButton()
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back! It's great to see you!",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(VoidCallback validateForm, LoginViewModel model) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInputField(
            controller: _emailController,
            label: 'Email',
            hintText: 'Enter your email address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email address';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextInputField(
            controller: _passwordController,
            label: 'Password',
            hintText: 'Enter your password',
            obscureText: !_isPasswordVisible,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Image.asset(
                  'assets/icons/${_isPasswordVisible ? 'password-hidden' : 'password-shown'}.png',
                  width: 8,
                  height: 8,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          _buildForgotPassword(),
          SizedBox(height: 24),
          _buildLoginButton(validateForm, model),
        ],
      ),
    );
  }

  Widget _buildLoginButton(VoidCallback validateForm, LoginViewModel model) {
    return ElevatedButton(
      onPressed: model.isBusy ? null : validateForm,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: AppTheme.themeData.primaryColor,
      ),
      child: model.isBusy
          ? SizedBox(
              height: 23,
              width: 23,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.themeData.primaryColorDark),
              ),
            )
          : Text(
              'Log In',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.themeData.primaryColorLight),
            ),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () => Navigator.pushNamed(
          context,
          RoutePaths.forgotPassword,
        ),
        child: Text(
          'Forgot Password?',
          style: TextStyle(color: AppTheme.themeData.primaryColorDark),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, RoutePaths.signUp),
          child: Text(
            'Sign Up',
            style: TextStyle(color: AppTheme.themeData.primaryColor),
          ),
        ),
      ],
    );
  }
}
