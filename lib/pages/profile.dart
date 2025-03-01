import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wuct/providers/auth_provider.dart';
import 'package:wuct/services/auth_service.dart';
import 'package:wuct/services/storage_service.dart';
import 'package:wuct/shared/custom_app_bar.dart';
import 'package:wuct/shared/custom_snack_bar.dart';
import 'package:wuct/shared/styled_button.dart';
import 'package:wuct/shared/styled_text.dart'; // Import CustomSnackBar

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  bool isEditingTeamID = false;
  bool isEditingTopicsID = false;
  bool isEditingIndividualID = false;
  bool isLoading = false;

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
    final authState = ref.watch(authProvider);

    void setIsLoading(bool val) {
      setState(() {
        isLoading = val;
      });
    }

    return Scaffold(
      appBar: const CustomAppBar(label: 'Profile'),
      body: authState.when(
        data: (user) {
          if (user != null) {
            // Initialize controllers with user data
            _teamIDController = TextEditingController(text: user.teamID);
            _topicsIDController = TextEditingController(text: user.topicsID);
            _individualIDController =
                TextEditingController(text: user.individualID);

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StyledBodyText(
                      'Email: ${user.email}',
                      fontSize: 18,
                    ),
                    const SizedBox(height: 8),
                    if (user.washuID.isNotEmpty)
                      StyledBodyText(
                        'WashU ID: ${user.washuID}',
                        fontSize: 18,
                      ),
                    const SizedBox(height: 8),
                    StyledBodyText(
                      'Admin Status: ${user.isAdmin ? 'Yes' : 'No'}',
                      fontSize: 18,
                    ),
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
                          setState(() {
                            isEditingTeamID = false;
                          });
                          if (user.teamID == _teamIDController.text) return;
                          await AuthService.changeValue(
                              user.uid, 'teamID', _teamIDController.text);

                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(
                                label: 'Team ID updated successfully'),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            CustomSnackBar(label: 'Error updating Team ID: $e'),
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
                          setState(() {
                            isEditingTopicsID = false;
                          });
                          if (user.topicsID == _topicsIDController.text) return;
                          await AuthService.changeValue(
                              user.uid, 'topicsID', _topicsIDController.text);

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
                          setState(() {
                            isEditingIndividualID = false;
                          });
                          if (user.individualID ==
                              _individualIDController.text) {
                            return;
                          }
                          await AuthService.changeValue(user.uid,
                              'individualID', _individualIDController.text);

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
                    const SizedBox(height: 16),

                    // Schedule Image Upload/Delete
                    user.scheduleImageURL.isNotEmpty
                        ? Center(
                            child: Column(
                              children: [
                                const StyledBodyText(
                                  'Your schedule:',
                                  fontSize: 16,
                                ),
                                const SizedBox(height: 16),
                                Image.network(user.scheduleImageURL),
                                const SizedBox(height: 16),
                                StyledButton(
                                  onPressed: () async {
                                    setIsLoading(true);
                                    await StorageService.deleteImage(
                                        user.scheduleImageURL, user.uid);
                                    setIsLoading(false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      CustomSnackBar(
                                          label:
                                              'Schedule deleted successfully'),
                                    );
                                  },
                                  buttonColor: Colors.red,
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const StyledButtonText(
                                          'Delete Schedule'),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              StyledButton(
                                onPressed: () async {
                                  setIsLoading(true);
                                  await StorageService.uploadImage(user.uid);
                                  setIsLoading(false);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    CustomSnackBar(label: 'Schedule updated'),
                                  );
                                },
                                buttonColor: Colors.blue,
                                child: isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const StyledButtonText('Upload Schedule'),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No user data available'));
          }
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Colors.blue)),
        error: (error, stackTrace) =>
            Center(child: Text('Error loading user data: $error')),
      ),
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
                  style: GoogleFonts.poppins(fontSize: 18),
                )
              : GestureDetector(
                  onTap: onEdit,
                  child: Text(
                    '$label: $value',
                    style: GoogleFonts.poppins(fontSize: 18),
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
