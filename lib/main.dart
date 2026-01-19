import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/theme_data.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/auth/login_screen.dart';
import 'package:parfimerija_app/screens/auth/register_screen.dart';
import 'package:parfimerija_app/screens/root_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Parfimerija',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            //home: const RootScreen(),
            //home: const LoginScreen(),
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(
                onLoginSuccess: () {
                  // Šta se desi kad se korisnik uloguje
                  Navigator.pushReplacementNamed(context, '/root');
                },
              ),
              '/register': (context) => const RegisterScreen(),
              '/root': (context) => const RootScreen(),
            },
          );
        },
      ),
    );
  }
}
