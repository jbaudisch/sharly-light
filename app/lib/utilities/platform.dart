import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

// This file contains several small useful functions/tools

/// Returns whether the app is being executed on Desktop (Windows, Mac, Linux, Web)
bool get isDesktop {
  return !kIsWeb &&
      (Platform.isLinux || Platform.isWindows || Platform.isMacOS);
}

bool get isMobile => !isDesktop;

/// Returns whether the app is being executed on a Windows device.
bool get isWindows {
  return !kIsWeb && Platform.isWindows;
}

/// Returns whether the current system support dynamic theming.
bool get supportsDynamicTheming {
  return !kIsWeb &&
      (Platform.isWindows ||
          Platform.isMacOS ||
          Platform.isLinux ||
          Platform.isAndroid);
}

bool get isAndroid {
  return !kIsWeb && Platform.isAndroid;
}

bool get isIOS => !kIsWeb && Platform.isIOS;