import 'package:flutter/material.dart';

class InfoBlock extends StatelessWidget {
  final String text;
  const InfoBlock({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
      decoration: BoxDecoration(
        color: Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFE0E0E0)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFF22605D),
          fontSize: 15,
          fontWeight: FontWeight.w500,
          height: 1.5,
        ),
      ),
    );
  }
}
