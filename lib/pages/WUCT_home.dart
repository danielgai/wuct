import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wuct/pages/web_view_container.dart';
import 'package:wuct/pages/buttons/webview_button.dart';
import 'package:wuct/pages/buttons/button.dart';
import 'package:wuct/button_pages/socials.dart';
import 'package:wuct/button_pages/registration.dart';
import 'package:wuct/button_pages/feedback.dart';
import 'package:wuct/button_pages/notifications.dart';

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
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/WUCT_Home.png'),
              fit: BoxFit.cover,
              alignment: Alignment(0.0, -0.25),
            ),
          ),
        ),

        // title: Text(
        //   'WashU Chemistry Tournament',
        //   style: TextStyle(
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // centerTitle: true,
        toolbarHeight: 111,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
        ],
      ),

      //expanded widget to take whole space
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
            Button(action: (){ Navigator.of(context).pushNamed('/login');}, label: 'Login', icon: Icons.login),
              Button(action: (){Navigator.of(context).pushNamed('/registration');}, label: 'Registration', icon: Icons.person_add),
              WebButton(url: 'https://wuct.wustl.edu/mobileschedule.html', label: 'Schedule', icon: Icons.event),
            ],
          ),
        Row(
          children: [
            Button(action: (){}, label: 'Find Room', icon: Icons.directions),
            Button(action: (){Navigator.of(context).pushNamed('/notifications');}, label: 'Notifications', icon: Icons.notifications),
            WebButton(url: 'https://wuct.wustl.edu/faq.html', label: 'FAQs', icon: Icons.help),
            //potentially code FAQ yourself, or replace w something else.
            //like waivers or something
          ],
        ),
        Row(
          children:[
            WebButton(url: 'https://wuct.wustl.edu/mobileabout.html', label: 'About', icon: Icons.info),
            Button(action: (){Navigator.of(context).pushNamed('/feedback');}, label: 'Feedback', icon: Icons.chat),
            Button(action: (){Navigator.of(context).pushNamed('/socials');}, label: 'Social', icon: Icons.share),

          ]
        ),],
      ),
      //listview or iterate through to output buttons?
      //account for different rows(?)

      backgroundColor: Colors.white,
      //the minute we have a child, the container
      //restricts itself to the size of child widget



      // floatingActionButton: FloatingActionButton(
      //   child: Text('click me'),
      //   onPressed: null,
      //   backgroundColor: Colors.green[900],
      // ),

    );
  }
}
