import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileDrawer extends StatelessWidget {
  final User? user; // User object passed from the login session

  const ProfileDrawer({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder<String?>(
                  future: _getStoredName(user), // Pass user to fetch name
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data != null) {
                      return Text(
                        'Name: ${snapshot.data}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              // Navigate to the profile page or perform any other action
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              await _signOut(context);
            },
          ),
        ],
      ),
    );
  }

  Future<String?> _getStoredName(User? user) async {
    if (user != null) {
      try {
        // Extract the username without the domain suffix
        String usernameWithoutDomain =
            user.email!.split('@').first.toUpperCase();
        print(usernameWithoutDomain);
        // Get the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Query Firestore to find the document where the rollno matches the username without the domain suffix
        QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
            .collection('students_details')
            .where('rollno', isEqualTo: usernameWithoutDomain)
            .get();
        print(snapshot.docs);
        // If a document is found, extract and return the name
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.data()['name'];
        } else {
          // If no document is found, return null
          print("no data is get");
          return null;
        }
      } catch (e) {
        print('Error fetching name from Firestore: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigate back to the login screen
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } catch (e) {
      print("Error signing out: $e");
    }
  }
}
