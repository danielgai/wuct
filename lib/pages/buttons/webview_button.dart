import 'package:flutter/material.dart';

class WebButton extends StatelessWidget{
  //const WebButton({Key? key}) : super(key: key);

  String label="";
  String url="";
  final IconData icon;


  WebButton({super.key, required this.url, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ElevatedButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/webViewContainer', arguments: url);
        },
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0), // Remove elevation
          overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove overlay color
          shadowColor: WidgetStateProperty.all(Colors.transparent), // Remove shadow color
          shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))), // Remove border
        ),
        child: Column(
          children:[
            Icon(
              icon,
              size: 100,
              color: Colors.green[900],
            ),
            const SizedBox(height: 8),
            Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )
            )
          ],
        ),
      ),
    );
  }



}


