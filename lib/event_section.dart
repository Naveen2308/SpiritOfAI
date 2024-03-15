import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme_provider.dart';
import 'home_section.dart';
import 'registration_section.dart';
import 'gallery_section.dart';
import 'idea_submission_page.dart';
import 'dashboard_section.dart';
import 'profile_drawer.dart';

class EventSection extends StatefulWidget {
  @override
  _EventSectionState createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  int _currentIndex = 0;
  late User? _currentUser; // Declare _currentUser here

  final List<Widget> _sections = [
    HomeSection(),
    RegistrationSection(),
    GallerySection(galleryImages: []),
    IdeaSubmissionPage(),
    DashboardSection(),
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      _currentUser = user;
    });
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events by Spirit of AI'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              ThemeProvider themeProvider =
                  Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme();
            },
          ),
        ],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () => _openDrawer(context),
          ),
        ),
      ),
      drawer: ProfileDrawer(
          user: _currentUser), // Pass the current user information
      body: Column(
        children: [
          Expanded(
            child: _sections[_currentIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_reg),
            label: 'Registration',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb),
            label: 'Idea Submission',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: EventSection(),
    ),
  );
}
