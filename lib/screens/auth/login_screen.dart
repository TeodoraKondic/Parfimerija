import 'package:flutter/material.dart';
import 'package:parfimerija_app/main.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/auth/register_screen.dart';
import 'package:parfimerija_app/screens/root_screen.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required void Function() onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final buttonBackground = themeProvider.getIsDarkTheme
        ? AppColors.lightVanilla
        : AppColors.chocolateDark;

    final buttonForeground = themeProvider.getIsDarkTheme
        ? AppColors.chocolateDark
        : AppColors.softAmber;

    return Scaffold(
      backgroundColor: themeProvider.getIsDarkTheme
          ? AppColors.chocolateDark
          : AppColors.softAmber,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Application',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeProvider.getIsDarkTheme
                    ? AppColors.softAmber 
                    : AppColors.chocolateDark,
              ),
            ),
            const SizedBox(height: 30),

            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBackground,
                foregroundColor: buttonForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                currentUser = UserType.user; // postavljamo običnog korisnika
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RootScreen()),
                );
              },
              child: const Text('Log in'),
            ),

            const SizedBox(height: 16),

  
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: buttonBackground, 
              ),
              onPressed: () {
                currentUser =
                    UserType.guest; // postavlja tip korisnika na gosta
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RootScreen()),
                );
              },
              child: const Text("Continue as Guest"),
            ),

            const SizedBox(height: 16),

    
            TextButton(
              style: TextButton.styleFrom(foregroundColor: buttonBackground),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
