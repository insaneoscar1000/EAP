import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:the_eap_app/src/ui/shared/theme.dart';

void showToast(String text) {
  showSimpleNotification(
      Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      background: AppTheme.themeData.primaryColor);
}
