import 'package:flutter/material.dart';
import 'package:flutter_application_sd/dtos/User.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

import 'EmailVerificationPage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _username, _password, _firstName, _lastName, _email;
  bool _isPasswordVisible = false; 
  bool _isLoading = false;

  Duration get loginTime => Duration(milliseconds: 2250);

  Future<void> _registerUser(User user) async {
    try {
      final response = await Model.sharedInstance.registerUser(user);

      if (response) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailVerificationPage(email: user.email ?? ''),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration failed. Please try again.')),
        );
      }
    } catch (e) {
      print("Error during registration: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred during registration: $e')),
      );
    }
  }

  Widget _buildTextField({
    required String label,
    required String? Function(String?)? validator,
    required void Function(String?)? onSaved,
    TextInputType inputType = TextInputType.text,
    bool obscureText = false,
    Widget? prefixIcon,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: inputType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF001F3F)),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF001F3F)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Color(0xFF001F3F), width: 2),
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    final passwordRegEx = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{10,}$');
    if (!passwordRegEx.hasMatch(value)) {
      return 'Password must be at least 10 characters, include upper and lower case letters, numbers, and special characters';
    }
    return null;
  }

  Widget _buildUsernameField() {
    return _buildTextField(
      label: "Username",
      validator: (value) => value == null || value.isEmpty ? 'Username is required' : null,
      onSaved: (value) => _username = value,
      prefixIcon: const Icon(Icons.person, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      label: "Password",
      obscureText: !_isPasswordVisible, // Usa lo stato per decidere la visibilità
      validator: _validatePassword,
      onSaved: (value) => _password = value,
      prefixIcon: const Icon(Icons.lock, color: Color(0xFF001F3F)),
      suffixIcon: IconButton(
        icon: Icon(
          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          color: Color(0xFF001F3F),
        ),
        onPressed: () {
          setState(() {
            _isPasswordVisible = !_isPasswordVisible; // Cambia lo stato
          });
        },
      ),
    );
  }

  Widget _buildFirstNameField() {
    return _buildTextField(
      label: "First Name",
      validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
      onSaved: (value) => _firstName = value,
      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildLastNameField() {
    return _buildTextField(
      label: "Last Name",
      validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
      onSaved: (value) => _lastName = value,
      prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF001F3F)),
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      label: "Email",
      inputType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Enter a valid email';
        }
        return null;
      },
      onSaved: (value) => _email = value,
      prefixIcon: const Icon(Icons.email, color: Color(0xFF001F3F)),
    );
  }

  void _submitForm() {
    if (_isLoading) return;

    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    User user = User(
      username: _username,
      password: _password,
      firstName: _firstName,
      lastName: _lastName,
      email: _email,
    );

    _registerUser(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Create Your Account",
                  style: TextStyle(
                    color: Color(0xFF001F3F),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildUsernameField(),
                      _buildPasswordField(),
                      _buildFirstNameField(),
                      _buildLastNameField(),
                      _buildEmailField(),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF001F3F),
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Register",
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Color(0xFF001F3F)),
              ),
            ),
        ],
      ),
    );
  }
}
