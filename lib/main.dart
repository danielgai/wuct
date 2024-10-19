import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/pages/login.dart';
import 'package:wuct/pages/notifications_page.dart';
import 'package:wuct/pages/signup.dart';
import 'package:wuct/pages/web_view_container.dart';
import 'package:wuct/pages/wuct_home.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/notification_service.dart';
import 'package:wuct/services/screen_stack_observer.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  //this allows Firebase to use platform channels to call native code
//which it needs to do to initialize itself. w/o it, Firebase may
  //not work correctly in app
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService().initNotifications();

//paste in BEFORE you run the app. Needs to get firebase ready before it starts
//connect to app in firebase before the app actually starts

  runApp(ProviderScope(
    child: MaterialApp(
      //theme: ThemeData(useMaterial3: true),
      //initialRoute: '/home',
      navigatorObservers: [ScreenStackObserver()],
      routes: {
        '/': (context) => const Loading(),
        //normally will be Loading() but you're learning google maps
        '/home': (context) => Consumer(builder: (context, ref, child) {
              final AsyncValue<AppUser?> user = ref.watch(authProvider);
              return user.when(
                  data: (user) {
                    return const WUCTHome();
                  },
                  error: (error, _) =>
                      const Text('Error loading auth status...'),
                  loading: () => const Loading());
            }),
        // } WUCTHome(),
        '/webViewContainer': (context) => const WebViewApp(),
        '/notifications': (context) => const NotificationsPage(),
        // '/campusMap': (context) => const CampusMap(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupForm()
      },
      // home: WebViewApp(),
      //throws an error if you have both home property and / cause of redundancy
      //will comment OUT home property here for now
    ),
  ));
}
