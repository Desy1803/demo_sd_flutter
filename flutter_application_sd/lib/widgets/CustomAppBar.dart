import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color backgroundColor;
  final Color titleColor;
  final List<Widget> actions; 

  CustomAppBar({
    this.title = 'Trading Reports',
    this.showBackButton = true,
    this.backgroundColor = const Color(0xFF001F3F),
    this.titleColor = Colors.white,
    this.actions = const []
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      toolbarHeight: 120, 
      flexibleSpace: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: backgroundColor,
            child: Row(
              children: [
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
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                ...actions,
              ],
            ),
          ),
          Container(
            height: 50,
            color: Color(0xFF001F3F).withOpacity(0.9),
            child: Row(
              children: [
                _buildNavItem(context, 'Home', '/'),
                _buildNavItem(context, 'Personal Area', '/personal-areas'),
                _buildNavItem(context, 'News', '/news'),
                _buildNavItem(context, 'Global Status Market', '/global-status-market'),
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
  Size get preferredSize => Size.fromHeight(120);
}
