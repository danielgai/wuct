import 'package:flutter/material.dart';
class WebButton extends StatefulWidget {
  //const WebButton({Key? key}) : super(key: key);

  String label="";
  String url="";
  final Icon icon;


  WebButton({required this.url, required this.label, required this.icon});

  @override
  State<WebButton> createState() => _WebButtonState();



}

class _WebButtonState extends State<WebButton> {


  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: (){},
      icon: widget.icon,
      label: Text(widget.label),
    );
  }
}

