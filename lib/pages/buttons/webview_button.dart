import 'package:flutter/material.dart';
import 'package:wuct/pages/web_view_container.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WebButton extends StatelessWidget{
  //const WebButton({Key? key}) : super(key: key);

  String label="";
  String url="";
  final IconData icon;


  WebButton({required this.url, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: ElevatedButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/webViewContainer', arguments: url);
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0), // Remove elevation
          overlayColor: MaterialStateProperty.all(Colors.transparent), // Remove overlay color
          shadowColor: MaterialStateProperty.all(Colors.transparent), // Remove shadow color
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))), // Remove border
        ),
        child: Column(
          children:[
            Icon(
              icon,
              size: 100,
              color: Colors.green[900],
            ),
            SizedBox(height: 8),
            Text(
                label,
                style: TextStyle(
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


