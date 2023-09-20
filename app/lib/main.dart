import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sharly_app_light/models/activity_index.dart';
import 'package:sharly_app_light/models/model_parent.dart';
import 'package:sharly_app_light/screens/activity_index.dart';
import 'package:sharly_app_light/services/background/background_service.dart';
import 'package:sharly_app_light/services/notifications.dart';
import 'package:sharly_app_light/utilities/global_navigator_state.dart';
import 'package:sharly_app_light/utilities/platform.dart';
import 'package:sharly_app_light/utilities/themes.dart';

import 'models/notification_payload/notification_payload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationPayload? notificationPayload;
  if (isAndroid || isIOS) {
    // TODO: Request notification permission
    await initializeService();
    await initializeNotifications();
    final details = await FlutterLocalNotificationsPlugin()
        .getNotificationAppLaunchDetails();
    final payload = details?.notificationResponse?.payload;
    if (payload != null) {
      try {
        notificationPayload ??=
            NotificationPayload.fromJson(jsonDecode(payload));
      } catch (e, s) {
        debugPrint("Failed to decode notification payload: $e");
        debugPrintStack(stackTrace: s);
      }
    }
  }


  runApp(SharlyLight(notificationPayload: notificationPayload,));
}

class SharlyLight extends StatelessWidget {
  const SharlyLight({
    super.key,
    this.notificationPayload
  });

  final NotificationPayload? notificationPayload;

  @override
  Widget build(BuildContext context) {
    return ModelParent(child: MaterialApp(

      debugShowCheckedModeBanner: false,
      title: "Sharly Light",
      navigatorKey: globalNavigatorKey,
      theme: SharlyTheme.lightTheme,
      darkTheme: SharlyTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: notificationPayload != null
          ? screenFromNotificationPayload(notificationPayload!)
          : const ActivityIndexScreen(index: ActivityIndex.happy,),
      // locale: Locale(Platform.localeName),
    ));
  }
}
