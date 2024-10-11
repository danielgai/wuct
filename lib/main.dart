import 'package:flutter/material.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/pages/login.dart';
import 'package:wuct/pages/signup.dart';
import 'package:wuct/pages/web_view_container.dart';
import 'package:wuct/pages/wuct_home.dart';
import 'package:wuct/services/screen_stack_observer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
//this allows Firebase to use platform channels to call native code
//which it needs to do to initialize itself. w/o it, Firebase may
  //not work correctly in app

//paste in BEFORE you run the app. Needs to get firebase ready before it starts
//connect to app in firebase before the app actually starts

  runApp(
    MaterialApp(
      //theme: ThemeData(useMaterial3: true),
      //initialRoute: '/home',
      navigatorObservers: [ScreenStackObserver()],
      routes: {
        '/': (context) => const Loading(),
        //normally will be Loading() but you're learning google maps
        '/home': (context) => const WUCTHome(),
        '/webViewContainer': (context) => const WebViewApp(),
        // '/campusMap': (context) => const CampusMap(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupForm()
      },
      // home: WebViewApp(),
      //throws an error if you have both home property and / cause of redundancy
      //will comment OUT home property here for now
    ),
  );
}
