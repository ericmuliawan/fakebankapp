// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppShadow {
  static List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: const Color(0XFF18274B).withOpacity(0.08),
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0XFF18274B).withOpacity(0.12),
      blurRadius: 12,
      spreadRadius: -6,
      offset: const Offset(0, 6),
    ),
  ];
}
