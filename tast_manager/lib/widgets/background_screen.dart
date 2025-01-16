import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/assets_path.dart';

class BackgroundScreen extends StatelessWidget {
  const BackgroundScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SvgPicture.asset(
        AssetsPath.background,
        fit: BoxFit.cover,
        width: double.maxFinite,
        height: double.maxFinite,
      ),
      SafeArea(child: child)
    ]);
  }
}
