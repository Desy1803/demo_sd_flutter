import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesNotAuth/CompanySearchResultsPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color backgroundColor;
  final Color titleColor;
  final TextEditingController _searchController = TextEditingController();

  CustomAppBar({
    this.title = "Trading Reports",
    this.actions,
    this.showBackButton = true,
    this.backgroundColor = const Color(0xFF001F3F),
    this.titleColor = Colors.white,
  });

  void _onSearch(BuildContext context, String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanySearchResultsPage(category: query),
        ),
      );
      _searchController.clear(); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      toolbarHeight: 100,
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
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 200,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: titleColor),
                          hintText: 'Search companies...',
                          hintStyle: TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white24,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: TextStyle(color: titleColor),
                        onSubmitted: (query) => _onSearch(context, query),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.person, color: titleColor),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            color: backgroundColor.withOpacity(0.9),
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
  Size get preferredSize => Size.fromHeight(100);
}
