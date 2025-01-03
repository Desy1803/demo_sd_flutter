import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/UserResponse.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompaniesPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

Future<UserResponse> fetchUserData() async {
  return await Model.sharedInstance.getUser();
}

Future<void> deleteUserData() async {
  return Model.sharedInstance.deleteUser();
}

class PersonalDataSummaryPage extends StatefulWidget {
  @override
  _PersonalDataSummaryPageState createState() =>
      _PersonalDataSummaryPageState();
}

class _PersonalDataSummaryPageState extends State<PersonalDataSummaryPage> {
  late Future<UserResponse> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
      ),
      body: FutureBuilder<UserResponse>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 8),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            var userData = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Color(0xFF001F3F),
                    child: Icon(Icons.person_outline, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildEditableField(
                            label: "Username",
                            initialValue: userData.username ?? "",
                            enabled: false, // Disabling the text field
                            onChanged: (newUsername) {
                              userData.username = newUsername;
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildEditableField(
                            label: "First Name",
                            initialValue: userData.firstName ?? "",
                            enabled: false, // Disabling the text field
                            onChanged: (newFirstName) {
                              userData.firstName = newFirstName;
                            },
                          ),
                          const SizedBox(height: 8),
                          _buildEditableField(
                            label: "Last Name",
                            initialValue: userData.lastName ?? "",
                            enabled: false, // Disabling the text field
                            onChanged: (newLastName) {
                              userData.lastName = newLastName;
                            },
                          ),
                          const SizedBox(height: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEditableField(
                                label: "Email",
                                initialValue: userData.email ?? "",
                                enabled: false, 
                                onChanged: (newEmail) {
                                  userData.email = newEmail; 
                                },
                              ),
                              const SizedBox(height: 4),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildActionButton(
                    context: context,
                    label: "Delete Profile",
                    color: Colors.redAccent,
                    icon: Icons.delete_outline,
                    onConfirmed: () async {
                      await deleteUserData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => CompaniesPage()),
                        (route) => false, 
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(
              child: Text(
                'No data found.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required String initialValue,
    required bool enabled,
    required Function(String) onChanged,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF001F3F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF001F3F)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF001F3F), width: 2),
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required String label,
    required Color color,
    required IconData icon,
    required Future<void> Function() onConfirmed,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Confirmation"),
            content: Text("Are you sure you want to $label?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await onConfirmed();
                },
                child: const Text("Confirm"),
              ),
            ],
          ),
        );
      },
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        primary: color,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
        textStyle: const TextStyle(fontSize: 16),
      ),
    );
  }
}
