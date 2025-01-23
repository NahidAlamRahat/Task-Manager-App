import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';

/// A stateless widget that provides a background screen with an SVG image
/// and wraps the given child widget on top of the background.
class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({super.key, required this.child});

  /// The widget to display on top of the background.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Displays the SVG background image that fills the entire screen.
        SvgPicture.asset(
          AssetsPath.background,
          fit: BoxFit.cover,
          width: double.maxFinite,
          height: double.maxFinite,
        ),
        // Ensures the child widget respects safe areas (e.g., not overlapping the status bar).
        SafeArea(child: child),
      ],
    );
  }
}
