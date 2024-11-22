import 'package:flutter/material.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final Color titleColor;
  final List<Widget> actions; // Aggiungi il parametro actions per le azioni personalizzate

  CustomAppBar({
    this.title = 'Trading Reports',
    this.showBackButton = true,
    this.backgroundColor = const Color(0xFF001F3F),
    this.titleColor = Colors.white,
    this.actions = const [], // Azioni personalizzate (opzionali)
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      toolbarHeight: 120, // Altezza fissa per l'AppBar
      flexibleSpace: Column(
        children: [
          // Parte superiore dell'AppBar
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: backgroundColor,
            child: Row(
              children: [
                // Icona per tornare indietro
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                const SizedBox(width: 8),
                const Icon(Icons.show_chart, color: Colors.white, size: 26),
                const SizedBox(width: 8),
                // Titolo della AppBar
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                // Aggiungi le azioni personalizzate (se presenti)
                ...actions,
              ],
            ),
          ),
          // Menu sotto l'AppBar
          Container(
            height: 50,
            color: Color(0xFF001F3F).withOpacity(0.9),
            child: Row(
              children: [
                _buildNavItem(context, 'Home', '/'),
                _buildNavItem(context, 'Personal Area', '/personal-areas'),
                _buildNavItem(context, 'News', '/news'),
                _buildNavItem(context, 'About Us', '/about'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String label, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey[100],
            border: const Border(
              left: BorderSide(color: Colors.white70, width: 1),
              right: BorderSide(color: Colors.white70, width: 1),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(120); // Altezza fissa dell'AppBar
}
