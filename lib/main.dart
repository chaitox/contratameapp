import 'dart:io';

import 'package:contratame/src/services/bottomNavigationBar_Provider.dart';
import 'package:contratame/src/services/category_service.dart';
import 'package:contratame/src/services/geo_current_position.dart';
import 'package:contratame/src/services/order_service.dart';
import 'package:contratame/src/services/profesional_service.dart';
import 'package:contratame/src/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import 'package:contratame/src/services/auth_service.dart';
import 'package:contratame/src/services/chat_service.dart';
import 'package:contratame/src/services/socket_service.dart';

import 'package:contratame/src/routes/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

// Global key para la navegacion
final GlobalKey<NavigatorState> _navigator = new GlobalKey<NavigatorState>();

//canal
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,

);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //Ver donde se guarda el icono de la app para cambiar launch_background
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // HttpOverrides.global = new MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => BottomNavigationBarProvider()),
      ChangeNotifierProvider(create: (_) => CategoryService()),
      ChangeNotifierProvider(create: (_) => ChatService()),
      ChangeNotifierProvider(create: (_) => GeoServices()),
      ChangeNotifierProvider(create: (_) => OrderService()),
      ChangeNotifierProvider(create: (_) => ProfesionalService()),
      ChangeNotifierProvider(create: (_) => SocketService()),
    ],
    child: EasyLocalization(
        child: MyApp(),
        supportedLocales: [Locale('es'), Locale('eng')],
        fallbackLocale: Locale('es'),
        path: 'lang'),
  ));

  //This will handle our click if the app is in Foreground
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    debugPrint('payload: $payload');
    //A route must always start with "/"
    //If it doesn't start with "/" we get an error
    _navigator.currentState.pushNamed('/' + '$payload');
  });

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //If we are on iOS we ask for permissions
    if (Platform.isIOS) {
      FirebaseMessaging.instance.requestPermission();
    }
    //Handle the background notifications (the app is termianted)
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      //If there is data in our notification
      if (message != null) {
        //We will open the route from the field view
        //with the value definied in the notification
        print(message.data['view']);
        _navigator.currentState.pushNamed('/' + message.data['view']);
      }
    });

    //Handle the notification if the app is in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title, // Title of our notification
            notification.body, // Body of our notification
            NotificationDetails(
              android: AndroidNotificationDetails(
                // This is the channel we use defined above
                channel.id,
                channel.name,
                channel.description,
                //The icon is defined in android/app/src/main/res/drawable
                icon: 'ic_notificacion',
              ),
            ),
            //We parse the data from the field view to the callback
            //Line 58
            payload: message.data["view"]);
      }
    });
    FirebaseMessaging.instance
        .subscribeToTopic('test'); // subscribe to topic test
    //Handle the background notifications (the app is closed but not termianted)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('A new onMessageOpenedApp event was published!');
      _navigator.currentState.pushNamed('/' + message.data['view']);
    });
    getToken(); // print the token for Firebase test notifications in debug mode
  }

  void getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    FirebaseMessaging.instance.getToken.call().then((token) {
      sharedPreferences.setString('fcmToken', token);     
      debugPrint('Token: $token');
    });
  }

  @override
  Widget build(BuildContext context) {
    //FlutterStatusbarcolor.setStatusBarColor(AppColors.flutterStatusbarcolor);

    return MaterialApp(
      navigatorKey: _navigator,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Contratame App',
      initialRoute: 'loading',
      theme: ThemeData(
        appBarTheme:
            AppBarTheme(backgroundColor: AppColors.appBarbackgroundColor),
        scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
        primaryColor: AppColors.primary,
        disabledColor: AppColors.disabledColor,
      ),
      routes: appRoutes,
    );
  }
}

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
