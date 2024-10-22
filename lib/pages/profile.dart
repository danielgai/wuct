import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wuct/pages/loading.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/custom_snack_bar.dart'; // Import CustomSnackBar

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isEditingTeamID = false;
  bool isEditingTopicsID = false;
  bool isEditingIndividualID = false;

  late TextEditingController _teamIDController;
  late TextEditingController _topicsIDController;
  late TextEditingController _individualIDController;

  @override
  void dispose() {
    _teamIDController.dispose();
    _topicsIDController.dispose();
    _individualIDController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);

        return Scaffold(
          appBar: CustomAppBar(label: 'Profile'),
          body: authState.when(
            data: (user) {
              if (user != null) {
                _teamIDController = TextEditingController(text: user.teamID);
                _topicsIDController =
                    TextEditingController(text: user.topicsID);
                _individualIDController =
                    TextEditingController(text: user.individualID);

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
                      const SizedBox(height: 16),

                      // Editable Team ID
                      _buildEditableField(
                        'Team ID',
                        user.teamID,
                        isEditingTeamID,
                        _teamIDController,
                        onEdit: () {
                          setState(() {
                            isEditingTeamID = true;
                          });
                        },
                        onSave: () async {
                          try {
                            await AuthService.changeValue(
                                user.uid, 'teamID', _teamIDController.text);
                            setState(() {
                              isEditingTeamID = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Team ID updated successfully'),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Error updating Team ID: $e'),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Editable Topics ID
                      _buildEditableField(
                        'Topics ID',
                        user.topicsID,
                        isEditingTopicsID,
                        _topicsIDController,
                        onEdit: () {
                          setState(() {
                            isEditingTopicsID = true;
                          });
                        },
                        onSave: () async {
                          try {
                            await AuthService.changeValue(
                                user.uid, 'topicsID', _topicsIDController.text);
                            setState(() {
                              isEditingTopicsID = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Topics ID updated successfully'),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Error updating Topics ID: $e'),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 16),

                      // Editable Individual ID
                      _buildEditableField(
                        'Individual ID',
                        user.individualID,
                        isEditingIndividualID,
                        _individualIDController,
                        onEdit: () {
                          setState(() {
                            isEditingIndividualID = true;
                          });
                        },
                        onSave: () async {
                          try {
                            await AuthService.changeValue(user.uid,
                                'individualID', _individualIDController.text);
                            setState(() {
                              isEditingIndividualID = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Individual ID updated successfully'),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar(
                                  label: 'Error updating Individual ID: $e'),
                            );
                          }
                        },
                      ),
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
      },
    );
  }

  Widget _buildEditableField(
    String label,
    String value,
    bool isEditing,
    TextEditingController controller, {
    required VoidCallback onEdit,
    required VoidCallback onSave,
  }) {
    return Row(
      children: [
        Expanded(
          child: isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: label,
                  ),
                )
              : GestureDetector(
                  onTap: onEdit,
                  child: Text(
                    '$label: $value',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
        ),
        isEditing
            ? IconButton(
                icon: const Icon(Icons.check),
                onPressed: onSave,
              )
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
      ],
    );
  }
}
