import 'package:flutter/material.dart';
import 'package:checkmate/core/constants/app_colors.dart';

class AppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final String title;
  const AppAppbar({super.key, required this.actions, this.title = ''});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      actions: actions,
      title: title.isNotEmpty ? Text(title) : null,
    );
  }
}
