import 'package:flutter/material.dart';
import 'package:flutter_application_sd/pagesAuth/WriteArticle.dart';
import 'package:flutter_application_sd/widgets/CustomAppBar.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Trading Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Trading Reports, your ultimate platform for tracking the most significant companies in the world. Our website is designed to provide you with insights into both the latest developments and historical news, dating back as far as 2008.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              'Create Articles Your Way',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'With Trading Reports, you can create articles effortlessly. Whether you prefer to write manually or leverage the power of AI, we provide you with the tools to craft informative and engaging content.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Text(
              'Share Your Knowledge',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Our platform allows you to make your articles public, enabling other users to read and benefit from the wealth of knowledge shared by the community. Together, we can create a vibrant hub of information and insights.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WriteArticlePage()),
                  );
                },
                child: Text('Explore Now'),
                style: ElevatedButton.styleFrom(
                  primary:  Color(0xFF001F3F),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
