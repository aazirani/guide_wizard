import 'dart:async';

import 'package:boilerplate/constants/settings.dart';
import 'package:boilerplate/ui/my_app.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'di/components/service_locator.dart';

Future<void> main() async {
  return runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await setPreferredOrientations();
    await setupLocator();
    await FastCachedImageConfig.init(clearCacheAfter: SettingsConstants.cacheImageDuration);
    runApp(MyApp());
  }, (error, stack) {
    print(stack);
    print(error);
  });
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
