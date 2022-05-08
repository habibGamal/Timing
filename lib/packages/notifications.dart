import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationAPI {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  static const initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          'your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker'),
    );
  }

  static Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
  }) async {
    _notifications.initialize(initializationSettings);
    return _notifications.show(id, title, body, await _notificationDetails(),
        payload: 'null');
  }
}

// var initializationSettingsAndroid = AndroidInitializationSettings('app_icon'); // <- default icon name is @mipmap/ic_launcher
//    var initializationSettingsIOS = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
//    flutterLocalNotificationsPlugin.initialize(initializationSettings); 