import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'event_section.dart';
import 'login_page.dart';
import 'theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Define custom Firebase options
  FirebaseOptions firebaseOptions = FirebaseOptions(
    apiKey: "AIzaSyBhCQ3jQGnmegZSF7jzi2h2uLfasE1yCEM",
    authDomain: "myapp-f373f.web.app",
    databaseURL:
        "https://spriteofai-default-rtdb.asia-southeast1.firebasedatabase.app/",
    projectId: "spriteofai",
    appId: "1:252552655289:android:4f0f1be8e1331f4c76c668",
    messagingSenderId: "252552655289",
  );

  // Initialize Firebase with custom options
  await Firebase.initializeApp(
    options: firebaseOptions,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) {
          return MaterialApp(
            title: 'Events by Spirit of AI',
            themeMode: themeProvider.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: AnimatedSplashScreen(), // Set AnimatedSplashScreen as home
            routes: {
              '/login': (context) => LoginPage(),
              '/eventSection': (context) => EventSection(),
            },
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => LoginPage(),
              );
            },
          );
        },
      ),
    );
  }
}
