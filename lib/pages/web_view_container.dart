import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late final WebViewController controller;
  String url = '';
 // String pageName = '';
  //bool isLoading = true;

  @override
  void initState() {
    super.initState();
    //two dots means it will create the controller object
    //then sequentially run the method on that object

  }

  @override
  Widget build(BuildContext context) {

    url = ModalRoute.of(context)!.settings.arguments as String;


    controller = WebViewController()
      ..loadRequest(
        Uri.parse(url),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text('WUCT'),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
