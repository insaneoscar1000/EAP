import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:the_eap_app/src/core/constants/constants.dart';
import 'package:the_eap_app/src/core/view_models/view_models.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

class SignUpView extends StatefulWidget {
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _dateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      viewModelBuilder: () => SignUpViewModel(),
      builder: (BuildContext context, SignUpViewModel model, Widget? child) {
        void validateForm() async {
          if (_formKey.currentState!.validate()) {
            await model.handleSignUpProcess(
                context,
                _emailController.text,
                _passwordController.text,
                _firstNameController.text,
                _lastNameController.text,
                _dateController.text);
          }
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              BackgroundContainer(
                background: 'background-2',
              ),
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
                      _buildForm(validateForm, model.isBusy),
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
          'Hello! Please register to get started.',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(VoidCallback validateForm, bool isBusy) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInputField(
            controller: _firstNameController,
            label: 'First Name',
            hintText: 'Enter your first name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
          TextInputField(
            controller: _lastNameController,
            label: 'Last Name',
            hintText: 'Enter your last name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),
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
          DateInputField(
            controller: _dateController,
            label: 'Date of Birth (Optional)',
            hintText: 'Select a date',
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
          SizedBox(height: 16),
          TextInputField(
            controller: _confirmPasswordController,
            label: 'Confirm password',
            hintText: 'Enter your password again',
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
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          _buildForgotPassword(),
          SizedBox(height: 24),
          _buildSignUpButton(validateForm, isBusy),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildSignUpButton(VoidCallback validateForm, bool isBusy) {
    return ElevatedButton(
      onPressed: isBusy ? null : validateForm,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        minimumSize: Size(double.infinity, 50),
        backgroundColor: AppTheme.themeData.primaryColor,
      ),
      child: isBusy
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              'Sign up',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.themeData.primaryColorLight),
            ),
    );
  }

  Widget _buildForgotPassword() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By signing up, I accept The EAP App ',
        style: TextStyle(color: AppTheme.themeData.primaryColorDark),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: AppTheme.themeData.primaryColorDark,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => _launchURL('http://www.forgetthesocks.app/conditions'),
          ),
          TextSpan(
            text: ' and ',
            style: TextStyle(color: AppTheme.themeData.primaryColorDark),
          ),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: AppTheme.themeData.primaryColorDark,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap =
                  () => _launchURL('http://www.forgetthesocks.app/privacy'),
          ),
          TextSpan(
            text: '.',
            style: TextStyle(color: AppTheme.themeData.primaryColorDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account?'),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, RoutePaths.login),
          child: Text(
            'Login Now',
            style: TextStyle(color: AppTheme.themeData.primaryColor),
          ),
        ),
      ],
    );
  }
}
