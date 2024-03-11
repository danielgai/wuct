import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wuct/pages/web_view_container.dart';

class WUCTHome extends StatefulWidget {
  //const WUCTHome({Key? key}) : super(key: key);

  @override
  State<WUCTHome> createState() => _WUCTHomeState();
}

class _WUCTHomeState extends State<WUCTHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Image.asset('assets/WUCT_Home.png',
          fit: BoxFit.contain,
          height: 72,),
        centerTitle: true,
        toolbarHeight: 88,
        actions: [
          IconButton(onPressed: () => {}, icon: Icon(Icons.search)),
        ],

//list of Icons.
      //login, person_add



//use control q to see stuff
      ),

      //expanded widget to take whole space
      body: Text('random'),
      //the minute we have a child, the container
      //restricts itself to the size of child widget



      floatingActionButton: FloatingActionButton(
        child: Text('click me'),
        onPressed: null,
        backgroundColor: Colors.green[900],
      ),

    );
  }
}
