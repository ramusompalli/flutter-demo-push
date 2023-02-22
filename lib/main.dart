import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import './api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  OneSignal.shared.setAppId("b1fe33ba-cb66-48fd-85f2-b5cb23fd37e1");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String? token;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void getPermision() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void getToken() async {
    FirebaseMessaging f = FirebaseMessaging.instance;
    await f.getToken().then((value) => setState(() {
          token = value;
        }));
  }

  @override
  void initState() {
    // TODO: implement initState
    // FirebaseMessaging messaging = FirebaseMessaging.instance;
    // getPermision();
    // getToken();
    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");

      OneSignal.shared.setNotificationWillShowInForegroundHandler(
          (OSNotificationReceivedEvent event) {
        // Will be called whenever a notification is received in foreground
        // Display Notification, pass null param for not displaying the notification
        event.complete(event.notification);
      });

      OneSignal.shared
          .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
        // Will be called whenever a notification is opened/button pressed.
      });

      OneSignal.shared
          .setPermissionObserver((OSPermissionStateChanges changes) {
        // Will be called whenever the permission changes
        // (ie. user taps Allow on the permission prompt in iOS)
      });

      OneSignal.shared
          .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
        // Will be called whenever the subscription changes
        // (ie. user gets registered with OneSignal and gets a user ID)
      });

      OneSignal.shared.setEmailSubscriptionObserver(
          (OSEmailSubscriptionStateChanges emailChanges) {
        // Will be called whenever then user's email subscription changes
        // (ie. OneSignal.setEmail(email) is called and the user gets registered
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(onPressed: sendNotification, child: Text('text from one signal')),
            TextButton(
                onPressed: () async {
                  try {
                    final body = {
                      "direct_boot_ok": true,
                      "to":
                          "ehDMVERwRaWi-kQaNjf3Pq:APA91bEt9FnKXCtWhQNkQWX4k9ZajFdSuVunMvan5BxpPKiwMWBz_U3MXAZUp197F5lWLsdmI-aMHdCpesTN8utGCVBf7s_nGAY1NUttbRdO62ZdExY_2Ohlo6fQcQgHf4ACaXqR_Ft0",
                      "notification": {"title": "hello", "body": "welcome"}
                    };
                    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
                    var response = await http.post(url,
                        headers: {
                          HttpHeaders.contentTypeHeader: 'application/json',
                          HttpHeaders.authorizationHeader:
                              'key=AAAApS1PYMQ:APA91bE423VjF_I5A-EP6nfD76daNwBgwdSNMVPAEcdxYQrj-8f7iYUPViRIfThZM807B4lzyQt9uF7iWJsIPbDQzqAnz2o06nEeRP_IQxzvw7TM33nNjboG-QxevzT-mLcikzwUVkqe',
                        },
                        body: jsonEncode(body));
                    print('Response status: ${response.statusCode}');
                    print('Response body: ${response.body}');
                  } catch (e) {
                    print(e);
                  }
                },
                child: const Text('send Notification')),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
