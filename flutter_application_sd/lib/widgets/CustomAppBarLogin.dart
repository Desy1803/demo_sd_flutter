import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanySearchResultsPage.dart';

class CustomAppBarLogin extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color titleColor;
  final TextEditingController _searchController = TextEditingController();

  CustomAppBarLogin({
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
      backgroundColor: backgroundColor,
      flexibleSpace: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            color: backgroundColor,
            child: Row(
              children: [
                Icon(Icons.show_chart, color: titleColor, size: 24),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
          
                IconButton(
                  icon: Icon(Icons.person, color: titleColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }



  @override
  Size get preferredSize => Size.fromHeight(50);
}
