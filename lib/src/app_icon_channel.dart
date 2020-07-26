import 'dart:io';
import 'dart:typed_data';

import 'package:application_icon/src/adaptive_icon.dart';
import 'package:flutter/services.dart';

class ApplicationIcon {
  static const MethodChannel _channel = const MethodChannel('application_icon');

  /// Loads the app icon as a simple raw bitmap.
  /// This should be PNG encoded, but is not guaranteed.
  static Future<Uint8List> getAppIcon() async {
    final Uint8List hasAdaptiveIcon = await _channel.invokeMethod('bitmapIcon');
    return hasAdaptiveIcon;
  }

  /// Checks wether the application has an AdaptiveIcon as app icon.
  /// On platform other than Android this returns false.
  /// On Android SDK levels smaller than API Level 26
  /// (https://developer.android.com/about/versions/oreo/android-8.0)
  /// this returns false.
  static Future<bool> hasAdaptiveIcon() async {
    if (Platform.isAndroid) {
      final bool hasAdaptiveIcon =
          await _channel.invokeMethod('hasAdaptiveIcon');
      return hasAdaptiveIcon;
    } else {
      return false;
    }
  }

  /// Loads the app icon as an AdaptiveIcon.
  /// This should be PNG encoded, but is not guaranteed.
  static Future<AdaptiveIcon> getAdaptiveIcon() async {
    if (!Platform.isAndroid) {
      throw Exception('getAdaptiveIcon is only supported on Android');
    }
    final foreground = await _getAdaptiveForeground();
    final background = await _getAdaptiveBackground();

    return AdaptiveIcon(
      foreground: foreground,
      background: background,
    );
  }

  static Future<Uint8List> _getAdaptiveForeground() async {
    if (!Platform.isAndroid) {
      throw Exception('adaptiveForeground is only supported on Android');
    }
    final Uint8List hasAdaptiveIcon =
        await _channel.invokeMethod('adaptiveForeground');
    return hasAdaptiveIcon;
  }

  static Future<Uint8List> _getAdaptiveBackground() async {
    if (!Platform.isAndroid) {
      throw Exception('adaptiveBackground is only supported on Android');
    }
    final Uint8List hasAdaptiveIcon =
        await _channel.invokeMethod('adaptiveBackground');
    return hasAdaptiveIcon;
  }
}
