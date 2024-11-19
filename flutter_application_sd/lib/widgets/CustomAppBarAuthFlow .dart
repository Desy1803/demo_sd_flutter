import 'package:flutter/material.dart';

class CustomAppBarAuthFlow extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color titleColor;

  CustomAppBarAuthFlow({
    this.title = "Trading Reports",
    this.actions,
    this.showBackButton = true,
    this.backgroundColor = const Color(0xFF001F3F),
    this.titleColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 2,
      backgroundColor: backgroundColor,
      toolbarHeight: 50, 
      flexibleSpace: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (showBackButton)
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            if (showBackButton) const SizedBox(width: 8),

            const Icon(Icons.show_chart, color: Colors.white, size: 26),

            const SizedBox(width: 8),

            Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
            ),

            if (actions != null) ...[
              Spacer(),
              Row(children: actions!),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50); // Altezza compatta
}
