import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/shared/custom_app_bar.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: CustomAppBar(label: 'Profile'),
      body: authState.when(
        data: (user) {
          if (user != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${user.email}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('WashU ID: ${user.washuID}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Admin Status: ${user.isAdmin ? 'Yes' : 'No'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Indivudal ID: ${user.individualID ?? 'NONE'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Topics ID: ${user.topicsID ?? 'NONE'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Team ID: ${user.teamID ?? 'NONE'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user data available'));
          }
        },
        loading: () => const Center(child: Loading()),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading user data: $error')),
      ),
    );
  }
}
