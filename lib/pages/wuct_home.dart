import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/models/app_user.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_snack_bar.dart';
import 'package:wuct/shared/home_button.dart';
import 'package:wuct/providers/auth_provider.dart';

class WUCTHome extends ConsumerWidget {
  const WUCTHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<AppUser?> user = ref.watch(authProvider);

    return user.when(
      data: (user) {
        // Define a list of buttons with their properties
        final List<ButtonData> buttons = [
          if (user == null)
            ButtonData(
              label: 'Login',
              icon: Icons.login,
              onPressed: (context) {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          if (user == null)
            ButtonData(
              label: 'Registration',
              icon: Icons.person_add,
              onPressed: (context) {
                Navigator.of(context).pushNamed('/signup');
              },
            ),
          ButtonData(
            label: 'Schedule',
            icon: Icons.event,
            url: 'https://wuct.wustl.edu/mobileschedule.html',
          ),
          if (user != null)
            ButtonData(
              label: 'Find Room',
              icon: Icons.directions,
              onPressed: (context) {
                // Define your find room action here
              },
            ),
          if (user != null)
            ButtonData(
              label: 'Notifications',
              icon: Icons.notifications,
              onPressed: (context) {
                // Define your notifications action here
                Navigator.of(context).pushNamed('/notifications');
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
            url: 'https://wuct.wustl.edu/about.html',
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
          // Conditionally render "Send Announcement" button if the user is admin
          if (user != null && user.isAdmin)
            ButtonData(label: 'Send Announcement', icon: Icons.send),

          if (user != null)
            ButtonData(
              label: 'Logout',
              icon: Icons.logout,
              onPressed: (context) async {
                try {
                  await AuthService.signOut(ref);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(CustomSnackBar(label: 'Logout Successful'));
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(CustomSnackBar(label: e.toString()));
                }
              },
            )
        ];

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
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
      },
      error: (error, stackTrace) =>
          const Center(child: Text('Error loading user data')),
      loading: () => const Center(child: Loading()),
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
