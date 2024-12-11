import 'package:flutter/material.dart';

class LoginRecommendationPopup extends StatelessWidget {

  const LoginRecommendationPopup();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Login Required'),
      content: Text('You must be logged in to access this page. Please log in to continue.'),
      actions: [
        TextButton(
          child: Text('Login'),
          onPressed: () {
            Navigator.pushNamed(context, '/login');
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(); // Chiudi il pop-up senza fare nulla
          },
        ),
      ],
    );
  }
}
