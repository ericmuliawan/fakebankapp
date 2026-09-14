import 'package:flutter/material.dart';

import '../../token/index.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? margin;

  const AppleSignInButton({
    super.key,
    required this.onTap,
    this.width,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 56,
        width: width,
        margin: margin,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: Colors.white,
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.black.withOpacity(0.45), width: 1.2),
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(999),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apple, size: 22, color: Colors.black87),
                const SizedBox(width: 18),
                Text(
                  'btn_login_apple',
                  textAlign: TextAlign.left,
                  style: AppTextStyle.bodyLarge.apply(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.82),
                    fontSizeDelta: 2,
                    fontWeightDelta: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
