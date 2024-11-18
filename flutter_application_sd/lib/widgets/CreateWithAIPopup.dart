import 'package:flutter/material.dart';

class CreateWithAIPopup extends StatefulWidget {
  final VoidCallback onClose;

  const CreateWithAIPopup({required this.onClose});

  @override
  _CreateWithAIPopupState createState() => _CreateWithAIPopupState();
}

class _CreateWithAIPopupState extends State<CreateWithAIPopup> {
  String selectedOption = 'FUNDAMENTAL';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose Data Type"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<String>(
            title: Text("Create your article on Fundamental Data"),
            value: 'FUNDAMENTAL',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: Text("Create your article with Data Analysis"),
            value: 'ANALYSIS',
            groupValue: selectedOption,
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onClose(); 
          },
          child: Text("Close"),
        ),
        ElevatedButton(
          onPressed: () {
            // Chiamata al BE per creare l'articolo con AI
            print("Creating article with option: $selectedOption");
            widget.onClose(); // Chiudi il pop-up
          },
          child: Text("Create"),
        ),
      ],
    );
  }
}
