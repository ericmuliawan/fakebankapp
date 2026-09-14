// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../../token/index.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double? width;
  final EdgeInsets? margin;

  const GoogleSignInButton({
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
                const SizedBox(width: 18),
                Text(
                  'btn_login_google',
                  textAlign: TextAlign.left,
                  style: AppTextStyle.bodyLarge.apply(
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
