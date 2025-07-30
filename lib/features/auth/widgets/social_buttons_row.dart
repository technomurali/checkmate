import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/utils/social_svg.dart';
import 'package:checkmate/features/auth/controllers/msal_login.dart';
import 'package:checkmate/features/auth/social_media_auth/auth/auth_repository.dart';
import 'package:checkmate/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:msal_auth/msal_auth.dart';

class SocialButtonsRow extends StatelessWidget {
  final bool disabled;
  final VoidCallback? onDisabledTap;
  const SocialButtonsRow({
    super.key,
    this.disabled = false,
    this.onDisabledTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _SocialIcon(
          icon: SocialSvg.googleSvg,
          size: 18,
          disabled: disabled,
          onDisabledTap: onDisabledTap,
        ),
        _SocialIcon(
          icon: SocialSvg.appleSvg,
          size: 50,
          disabled: disabled,
          onDisabledTap: onDisabledTap,
        ),
        _SocialIcon(
          icon: SocialSvg.linkedInSvg,
          size: 29,
          disabled: disabled,
          onDisabledTap: onDisabledTap,
        ),
        _SocialIcon(
          icon: SocialSvg.windowsSvg,
          size: 24,
          disabled: disabled,
          onDisabledTap: onDisabledTap,
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final String icon;
  final double size;
  final bool disabled;
  final VoidCallback? onDisabledTap;
  const _SocialIcon({
    required this.icon,
    this.size = 28,
    this.disabled = false,
    this.onDisabledTap,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  late SingleAccountPca pca;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initPca();
  }

  _initPca() async {
    try {
      pca = await MsalLogin().initializeMsal();
    } catch (e) {
      print("Error initializing MSAL: $e");
    }
  }

  isAndroid() {}

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.disabled
          ? () {
              if (widget.onDisabledTap != null) widget.onDisabledTap!();
            }
          : () async {
              // TODO: Implement actual social signin
              if (widget.icon == SocialSvg.windowsSvg) {
                bool success = await MsalLogin().signIn(pca);
                if (success) {
                  Navigator.popAndPushNamed(
                    context,
                    RouteName.pharmaRepDashboard,
                  );
                }
              } else if (widget.icon == SocialSvg.appleSvg) {
                print("Windows sign-in failed");
              } else if (widget.icon == SocialSvg.googleSvg) {
                bool success = await AuthRepository().signIn(
                  SocialProvider.google,
                  ctx: context,
                );
                if (success) {
                  Navigator.popAndPushNamed(
                    context,
                    RouteName.pharmaRepDashboard,
                  );
                } else {
                  print("Google sign-in failed");
                }
              } else if (widget.icon == SocialSvg.linkedInSvg) {
                bool success = await AuthRepository().signIn(
                  SocialProvider.linkedin,
                  ctx: context,
                );
                if (success) {
                  Navigator.popAndPushNamed(
                    context,
                    RouteName.pharmaRepDashboard,
                  );
                } else {
                  print("LinkedIn sign-in failed");
                }
              } else {
                print(
                  "Social sign-in for ${widget.icon} is not implemented yet.",
                );
              }
            },
      borderRadius: BorderRadius.circular(24),
      child: Opacity(
        opacity: widget.disabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: SvgPicture.string(
              widget.icon,
              height: widget.size,
              width: 24,
            ),
          ),
        ),
      ),
    );
  }
}
