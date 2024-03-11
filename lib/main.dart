// import 'dart:ffi';
// import 'package:flutter/material.dart';
// import 'package:wuct/pages/WUCT_home.dart';
// import 'package:wuct/pages/Loading.dart';
// import 'package:wuct/pages/web_view_container.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
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

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'src/web_view_stack.dart';

void main() {
  runApp(
    const MaterialApp(
      //theme: ThemeData(useMaterial3: true),
      home: WebViewApp(),
    ),
  );
}

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://wuct.wustl.edu/wuctschedule'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}