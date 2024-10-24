import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pages/LoginPage.dart'; // Assicurati che questa importazione sia corretta
import 'package:flutter_application_sd/pages/CompaniesPage.dart'; // Importa la tua pagina delle aziende

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        PopupMenuButton<String>(
          icon: Icon(Icons.menu), // Tre trattini per l'icona del menu
          onSelected: (String value) {
            // Azioni da eseguire quando si seleziona un'opzione
            switch (value) {
              case 'Login':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // La tua pagina di login
                );
                break;
              case 'Info':
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Info'),
                      content: Text('Questa è una sezione informativa dell\'app.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Chiudi'),
                        ),
                      ],
                    );
                  },
                );
                break;
              case 'Impostazioni':
                // Naviga o mostra un contenuto relativo alle impostazioni
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Impostazioni'),
                      content: Text('Questa è la sezione delle impostazioni.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Chiudi'),
                        ),
                      ],
                    );
                  },
                );
                break;
              case 'Aziende':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompaniesPage()),  
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) {
            return {'Login', 'Info', 'Impostazioni', 'Aziende'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
