import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2), // Change duration to 4 seconds
    );
    _controller.forward().whenComplete(() {
      setupWUCTHome(context);
    });
  }

  void setupWUCTHome(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, -MediaQuery.of(context).size.height * _controller.value),
                child: Opacity(
                  opacity: 1 - _controller.value,
                  child: Container(
                    color: Colors.green[900],
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: SpinKitPulse(
                        color: Colors.white,
                        size: 50.0,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0.0, MediaQuery.of(context).size.height * (1 - _controller.value)),
                child: Opacity(
                  opacity: _controller.value,
                  child: Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Image.asset('assets/WUCT_Home.png', width: 200),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
