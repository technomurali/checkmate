import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButtonsRow extends StatelessWidget {
  const SocialButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _SocialIcon(icon: FontAwesomeIcons.google, size: 18),
        _SocialIcon(icon: Icons.apple),
        _SocialIcon(icon: FontAwesomeIcons.linkedinIn, size: 29),
        _SocialIcon(icon: FontAwesomeIcons.microsoft, size: 24),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  const _SocialIcon({required this.icon, this.size = 28});
  isAndroid() {}
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // TODO: Implement actual social login
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding:
            icon == FontAwesomeIcons.microsoft ||
                icon == FontAwesomeIcons.google
            ? EdgeInsets.all(12)
            : EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: FaIcon(icon, size: size),
      ),
    );
  }
}
