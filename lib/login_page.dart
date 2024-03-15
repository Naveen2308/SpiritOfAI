import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'event_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _domain = '@spiritofai.com';
  String _errorMessage = '';
  bool _isLoggingIn = false;

  Future<void> _login(BuildContext context) async {
    setState(() {
      _errorMessage = ''; // Clear previous error messages
    });

    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'All fields are required.';
      });
      return;
    }

    setState(() {
      _isLoggingIn = true; // Set logging in state to true
    });

    try {
      String email = _usernameController.text + _domain;
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );

      // Store the user's authentication state locally
      // Example: Using shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('username', _usernameController.text);
      // Navigate to the event section if login is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => EventSection(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException caught: ${e.code}");
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'No user found for that username.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Incorrect password provided.';
        });
      } else {
        setState(() {
          _errorMessage = 'Incorrect username or Password';
        });
      }
    } finally {
      setState(() {
        _isLoggingIn = false; // Reset logging in state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.lightBlue[100]!,
                  Colors.yellow[100]!,
                ],
                stops: [0.5, 1.0],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 2,
                child: ClipPath(
                  clipper: MyClipper(),
                  child: Container(
                    color: Colors.lightBlue,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Visibility(
                        visible: _errorMessage.isNotEmpty,
                        child: Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed: _isLoggingIn ? null : () => _login(context),
                        child: _isLoggingIn
                            ? CircularProgressIndicator() // Show loading indicator while logging in
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                               backgroundColor: const Color.fromARGB(255, 248, 245, 245),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                            ),
                            onPressed: () {
                              // Handle Instagram login
                            },
                            icon: Image.network(
                              'https://upload.wikimedia.org/wikipedia/commons/a/a5/Instagram_icon.png',
                              width: 24,
                              height: 24,
                            ),
                            label: Text(
                              'Instagram',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                               backgroundColor: Color.fromARGB(255, 95, 196, 255),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                            ),
                            onPressed: () {
                              // Handle Facebook login
                            },
                            icon: Icon(Icons.facebook, color: Colors.white),
                            label: Text(
                              'Facebook',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.7);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
