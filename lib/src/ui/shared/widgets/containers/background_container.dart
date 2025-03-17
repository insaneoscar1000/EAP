import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget? child;
  final String background;

  BackgroundContainer({required this.background, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/$background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}
