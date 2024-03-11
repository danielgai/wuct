import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
class WebViewContainer extends StatefulWidget {
//  const WebViewContainer({Key? key}) : super(key: key);
//can this clas be the "webview button" class?
  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  //initialize webview here

  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.disabled)
  ..loadRequest(Uri.parse('https://flutter.dev/'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("WebView Container")),
      body: WebViewWidget(controller: controller),
    );
  }
}
