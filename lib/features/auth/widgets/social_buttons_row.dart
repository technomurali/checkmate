import 'package:checkmate/core/constants/app_colors.dart';
import 'package:checkmate/core/utils/social_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

class _SocialIcon extends StatelessWidget {
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
  isAndroid() {}
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled
          ? () {
              if (onDisabledTap != null) onDisabledTap!();
            }
          : () {
              // TODO: Implement actual social signin
            },
      borderRadius: BorderRadius.circular(24),
      child: Opacity(
        opacity: disabled ? 0.5 : 1.0,
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Center(
            child: SvgPicture.string(icon, height: size, width: 24),
          ),
        ),
      ),
    );
  }
}
