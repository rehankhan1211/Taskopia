
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:hooks_riverpod/hooks_riverpod.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../features/todo/pages/view_not.dart';
import '../models/task_model.dart';

class NotificationsHelper {
  final WidgetRef ref;

  NotificationsHelper({required this.ref});

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  String? selectedNotificationPayload;

  final BehaviorSubject<String?> selectNotificationSubject =
      BehaviorSubject<String?>();

  initializeNotification() async{
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    final DarwinInitializationSettings initializationSettingsIOS=
        DarwinInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification
        );
    final AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings("calender");
    final InitializationSettings initializationSettings =
        InitializationSettings(
        android: androidInitializationSettings,
        iOS: initializationSettingsIOS,
        );
    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
      onDidReceiveNotificationResponse: (data) async {
          if(data != null) {
            debugPrint('notification payload: ${data.payload!}');
          }
          selectNotificationSubject.add(data.payload);
      });
  }

  void requestIOSPermissions(){
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    const String timeZoneName ='Asia/Kolkata';
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future  onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {

    showDialog(
      context: ref.context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title ?? ""),
        content: Text(body ?? ""),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Close'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          CupertinoDialogAction(
              child: const Text('View'),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      )
    );
  }
  scheduledNotifications(int days, int hours, int minutes, int seconds, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id??0,
      task.title,
      task.desc,
      tz.TZDateTime.now(tz.local)
        .add( Duration(days: days, hours: hours, minutes: minutes, seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your channel id',
          'your channel name'
        )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
        "${task.title}|${task.desc}|${task.date}|${task.startTime}|${task.endTime}",
    );
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async{
      var title = payload!.split('|')[0];
      var body = payload.split('|')[1];
      showDialog(
          context: ref.context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body, textAlign: TextAlign.justify,maxLines: 4,),
            actions: [
              CupertinoDialogAction(
                  isDestructiveAction: true,
                onPressed: (){
                    Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
              CupertinoDialogAction(
                  child: const Text('View'),
                onPressed: (){
                    Navigator.push(
                        context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NotificationsPage(payload: payload)));
                },
              )
            ],
          )
      );
    });
  }
}