import 'package:flutter/material.dart';

class PopButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 42,
      left: 16,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Theme.of(context).secondaryHeaderColor, width: 1),
          ),
          child: Center(
            child: Icon(
              Icons.chevron_left,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
