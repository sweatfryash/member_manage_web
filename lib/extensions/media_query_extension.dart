import 'package:flutter/material.dart';
import 'package:member_manage_web/extensions/window_type.dart';

extension MediaQueryExtension on MediaQueryData {
  WindowType get windowType {
    if (size.width < 600) {
      return WindowType.compact;
    } else if (size.width < 840) {
      return WindowType.medium;
    } else {
      return WindowType.expanded;
    }
  }

  bool get isCompact => windowType == WindowType.compact;
}
