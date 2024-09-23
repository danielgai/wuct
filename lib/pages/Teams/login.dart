import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  //stateful widget, alter UI depending on..


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
Expanded(flex: 6, child: Image.asset('assets/MugDesign.png'),),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),
              ),
              flex: 2,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle login logic here
                //will need to handle firebase stuff, here, perhaps the
                //factory constructor serializing

                //or, we handle this stuff in another class

                //need an await somewhere/loading screen
                //
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

//need a try and catch block