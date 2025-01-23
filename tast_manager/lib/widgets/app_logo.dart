import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';

/// A stateless widget that displays the application logo.
/// The logo is loaded as an SVG image using the file path defined in `AssetsPath`.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Loads and displays the logo SVG asset from the specified file path.
    return SvgPicture.asset(AssetsPath.logo);
  }
}
