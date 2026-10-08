import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/constants/route_constants.dart';
import 'package:the_eap_app/src/ui/shared/widgets/widgets.dart';

/// Landing screen of NEM: Air Quality (minimum emissions standards).
class NEMAQView extends StatelessWidget {
  static const Color teal = Color(0xFF00979B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: 'NEM: Air Quality',
        showBackButton: true,
        backgroundColor: teal,
      ),
      backgroundColor: Colors.white,
      body: BackgroundContainer(
        background: 'background-3',
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'NEM:AQA Minimum Emissions Standards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: teal),
                ),
                SizedBox(height: 20),
                Text.rich(
                  TextSpan(
                    style: TextStyle(fontSize: 16, color: teal, height: 1.4),
                    children: <InlineSpan>[
                      TextSpan(text: 'Consult '),
                      TextSpan(
                        text: 'GNR 893 of 22 November 2013',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '\n“List of Activities which may result in atmospheric emissions which have or may have a significant detrimental effect on the Environment, including health, social conditions, economic conditions, ecological conditions or cultural heritage.”',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: teal,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, RoutePaths.nemAqActivities),
                    child: Text(
                      'Check AQA:  Listed Activities  >',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(height: 56),
                Text(
                  'Also consult subsequent amendments:',
                  style: TextStyle(fontSize: 16, color: teal),
                ),
                SizedBox(height: 4),
                _amendment('GNR 551 of 12 June 2015'),
                _amendment('GNR 1207 of 31 October 2018'),
                _amendment('GNR 687 of 22 May 2019'),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _amendment(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: teal),
      ),
    );
  }
}
