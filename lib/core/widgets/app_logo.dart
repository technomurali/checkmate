import 'package:checkmate/core/constants/app_paths.dart';
import 'package:checkmate/core/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  final double width;

  const AppLogo({super.key, this.height = 0, this.width = -1})
    : assert(height > width);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width > 0 ? width : AppSizes().width,
      height: height > 0 ? height : AppSizes().height,
      child: Image.asset(AppPaths.logoPath, fit: BoxFit.fill),
    );
  }
}
