import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesAuth/PersonalArea.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompaniesPage.dart';
import 'package:flutter_application_sd/restManagers/HttpRequest.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> with SingleTickerProviderStateMixin {
  String? _email;
  String? _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

   Duration get loginTime => Duration(milliseconds: 2250);

  Future<String?> _authUser(String email, String password) async {
    return Future.delayed(loginTime).then((_) {
      return Model.sharedInstance.logIn(email, password);
    });
  }

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          prefixIcon: const Icon(Icons.email),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Mandatory email';
          }
          return null;
        },
        onSaved: (String? value) {
          _email = value;
        },
      ),
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          prefixIcon: const Icon(Icons.lock),
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Request password';
          }
          return null;
        },
        onSaved: (String? value) {
          _password = value;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CompaniesPage()),);
          },
        ),
        title: const Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF001F3F), 
      ),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: child,
          );
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          "Trading Reports",
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildEmail(),
                    _buildPassword(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        _formKey.currentState!.save();
                        print("Email: $_email");
                        print("Password: $_password");

                        String? result = await _authUser(_email!, _password!);

                        if (result == null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => PersonalArea()),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Login Failed"),
                              content: Text(result),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        backgroundColor: const Color(0xFF001F3F),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),

                                        const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        print("Navigating to Forgot Password...");
                        //TODO Aggiungi navigazione alla pagina "Forgot Password" quando implementata
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Color(0xFF001F3F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/registration");
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color(0xFF001F3F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
