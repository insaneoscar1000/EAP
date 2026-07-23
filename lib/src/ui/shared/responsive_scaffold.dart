import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Constrains content to a mobile-like max width on wide (web) screens.
///
/// On mobile (Android / iOS) this is a pass-through — the child is
/// returned untouched, so mobile sizing is never affected.
///
/// On web, when the viewport is wider than [breakpoint], the child is
/// centered inside a max-width column on a neutral page background so
/// the existing mobile-shaped views read as a deliberate web page
/// rather than a clipped phone screen.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    Key? key,
    required this.child,
    this.maxWidth = 900,
    this.breakpoint = 900,
  }) : super(key: key);

  final Widget child;
  final double maxWidth;
  final double breakpoint;

  // Soft warm-neutral page background — sits comfortably behind any
  // theme colour without competing with the inner content.
  static const Color _pageBackground = Color(0xFFF4F5F7);

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < breakpoint) {
      return child;
    }
    return ColoredBox(
      color: _pageBackground,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Material(child: child),
        ),
      ),
    );
  }
}
