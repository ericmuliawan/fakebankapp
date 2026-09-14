import 'package:flutter/material.dart';

extension PaginationScrollController on ScrollController {
  bool isReachBottom() {
    return position.maxScrollExtent == position.pixels;
  }

  bool isReachBottomInbox(ScrollController controller) {
    if (!controller.hasClients) return false; // Check if controller is attached
    const tolerance = 10.0; // Small tolerance for precision
    return controller.position.pixels >=
        controller.position.maxScrollExtent - tolerance;
  }
}
