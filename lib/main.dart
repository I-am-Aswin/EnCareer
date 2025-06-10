import 'package:en_career/core/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:en_career/providers/theme_provider.dart';
import 'screens/shared/splash_screen.dart';
import 'package:en_career/services/auth_service.dart';
import 'package:en_career/screens/auth/login_screen.dart';
import 'package:en_career/screens/shared/main_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(), // Don't wrap here!
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Career Guidance',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapshot.hasData) {
              return const MainNavigation();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}