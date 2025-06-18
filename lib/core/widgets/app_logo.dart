import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 59,
      child: Image.asset('assets/images/logo.png', fit: BoxFit.fill),
    );
  }
}
