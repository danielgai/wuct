
// void main() => runApp(MaterialApp(
//   //runs MaterialApp, which is root widget
//  // home: Home(),
//   initialRoute: '/home',
//
//   routes:{
//     '/': (context) => Loading(),
//     '/home': (context) =>WUCTHome(),
//     '/webViewContainer': (context) => WebViewContainer(),
//
//   }
//
// ));
//
// //all widgets are instances of classes
// //here, we are basically making our own
// //StatelessWidget is a basic widget? Helps
// //us access hot restart and view updates in real time
// //as app rebuilds the edited portion of the widget
// class Home extends StatelessWidget {
//
//
//   //override is used to say this build function will override the one defined in class' ancestor
//   //(ie StatelessWidget which has its own build function as well).
//   @override
//   Widget build(BuildContext context) {
//     //return a Widget
//     return Scaffold(
//     //make it so AppBar is primary navigator for app (e.g. google maps stuff, etc.)
//
//
//   );
//
//
//   }
// }

import 'dart:ffi';
import 'package:wuct/pages/Teams/login.dart';
import 'package:wuct/pages/WUCT_home.dart';
import 'package:wuct/pages/Loading.dart';
import 'package:wuct/pages/web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/web_view_stack.dart';
import 'package:wuct/pages/campus_map.dart';

//firebase
import 'package:firebase_core/firebase_core.dart';
//installed core firebase library. If we want
//specific firebase services like firestore databse
//we have to install separate package for those

import 'firebase_options.dart';

// ...



void main() async{
WidgetsFlutterBinding.ensureInitialized();
//this allows Firebase to use platform channels to call native code
//which it needs to do to initialize itself. w/o it, Firebase may
  //not work correctly in app

//paste in BEFORE you run the app. Needs to get firebase ready before it starts
//connect to app in firebase before the app actually starts
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MaterialApp(
      //theme: ThemeData(useMaterial3: true),
      //initialRoute: '/home',
 routes:{
    '/': (context) => Loading(),
   //normally will be Loading() but you're learning google maps
    '/home': (context) =>WUCTHome(),
    '/webViewContainer': (context) => WebViewApp(),
   '/campusMap': (context) => CampusMap(),
   '/login': (context) => LoginPage(),

  },
    // home: WebViewApp(),
      //throws an error if you have both home property and / cause of redundancy
      //will comment OUT home property here for now

    ),
  );
}

