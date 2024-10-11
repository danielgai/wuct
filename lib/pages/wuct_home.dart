import 'package:flutter/material.dart';
import 'package:wuct/shared/home_button.dart';

class WUCTHome extends StatefulWidget {
  const WUCTHome({super.key});

  @override
  State<WUCTHome> createState() => _WUCTHomeState();
}

class _WUCTHomeState extends State<WUCTHome> {
  // Define a list of buttons with their properties
  final List<ButtonData> buttons = [
    ButtonData(
      label: 'Login',
      icon: Icons.login,
      onPressed: (context) {
        Navigator.of(context).pushNamed('/login');
      },
    ),
    ButtonData(
      label: 'Registration',
      icon: Icons.person_add,
      onPressed: (context) {
        Navigator.of(context).pushNamed('/signup');

        // Define your registration action here
      },
    ),
    ButtonData(
      label: 'Schedule',
      icon: Icons.event,
      url: 'https://wuct.wustl.edu/mobileschedule.html',
    ),
    ButtonData(
      label: 'Find Room',
      icon: Icons.directions,
      onPressed: (context) {
        // Define your find room action here
      },
    ),
    ButtonData(
      label: 'Notifications',
      icon: Icons.notifications,
      onPressed: (context) {
        // Define your notifications action here
      },
    ),
    ButtonData(
      label: 'FAQs',
      icon: Icons.help,
      url: 'https://wuct.wustl.edu/faq.html',
    ),
    ButtonData(
      label: 'About',
      icon: Icons.info,
      url: 'https://wuct.wustl.edu/mobileabout.html',
    ),
    ButtonData(
      label: 'Feedback',
      icon: Icons.chat,
      onPressed: (context) {
        // Define your feedback action here
      },
    ),
    ButtonData(
      label: 'Social',
      icon: Icons.share,
      onPressed: (context) {
        // Define your social action here
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use SafeArea to avoid system UI overlaps
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            _buildAppBar(),
            // Expanded GridView for buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // Determine the number of columns based on screen width
                    int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1,
                      ),
                      itemCount: buttons.length,
                      itemBuilder: (context, index) {
                        return HomeButton(
                          label: buttons[index].label,
                          icon: buttons[index].icon,
                          url: buttons[index].url,
                          onPressed: buttons[index].onPressed,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Custom AppBar widget
  Widget _buildAppBar() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/WUCT_Home.png'),
          fit: BoxFit.cover,
          alignment: Alignment(0.0, -0.25),
        ),
      ),
    );
  }
}
