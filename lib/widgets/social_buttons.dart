import 'package:flutter/material.dart';

class SocialButtons extends StatelessWidget {
  final VoidCallback? onGooglePressed;
  final VoidCallback? onFacebookPressed;

  const SocialButtons({
    super.key,
    this.onGooglePressed,
    this.onFacebookPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIcon('assets/images/google.webp', onGooglePressed),
        const SizedBox(width: 16),
        _buildSocialIcon('assets/images/fb2.webp', onFacebookPressed),
      ],
    );
  }

  Widget _buildSocialIcon(String assetPath, VoidCallback? onPressed) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Image.asset(assetPath, width: 24, height: 24),
        onPressed: onPressed,
      ),
    );
  }
}
