import 'package:flutter/material.dart';
import 'package:wuct/pages/buttons/webview_button.dart';
import 'package:wuct/pages/buttons/button.dart';

class WUCTHome extends StatefulWidget {
  const WUCTHome({super.key});

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
          decoration: const BoxDecoration(
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
            icon: const Icon(Icons.search),
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
              Button(action: (){}, label: 'Registration', icon: Icons.person_add),
              WebButton(url: 'https://wuct.wustl.edu/mobileschedule.html', label: 'Schedule', icon: Icons.event),
            ],
          ),
        Row(
          children: [
            Button(action: (){}, label: 'Find Room', icon: Icons.directions),
            Button(action: (){}, label: 'Notifications', icon: Icons.notifications),
            WebButton(url: 'https://wuct.wustl.edu/faq.html', label: 'FAQs', icon: Icons.help),
            //potentially code FAQ yourself, or replace w something else.
            //like waivers or something
          ],
        ),
        Row(
          children:[
            WebButton(url: 'https://wuct.wustl.edu/mobileabout.html', label: 'About', icon: Icons.info),
            Button(action: (){}, label: 'Feedback', icon: Icons.chat),
            Button(action: (){}, label: 'Social', icon: Icons.share),

          ]
        ),],
      ),
      //listview or iterate through to output buttons?
      //account for different rows(?)

      backgroundColor: Colors.white,
      //the minute we have a child, the container
      //restricts itself to the size of child widget



      floatingActionButton: FloatingActionButton(
        onPressed: null,
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),

    );
  }
}
