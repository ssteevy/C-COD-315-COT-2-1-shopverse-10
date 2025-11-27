import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login.dart';
import 'screens/auth/register.dart';
import 'wrapper/auth_wrapper.dart';
import 'screens/splash/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const Shopverse());
}

class Shopverse extends StatelessWidget {
  const Shopverse({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..listenToAuthChanges(),
        ),
      ],
      child: MaterialApp(
        title: 'ShopVerse',
        debugShowCheckedModeBanner: false,

        // THEMES
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // WRAPPER AUTH
        home: const SplashScreen(),

        // ROUTES
        routes: {
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/auth-wrapper': (_) => const AuthWrapper(),
        },
      ),
    );
  }
}
