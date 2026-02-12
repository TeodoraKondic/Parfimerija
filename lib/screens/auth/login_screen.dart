import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/main.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.getIsDarkTheme;

    final scaffoldBg = isDark ? AppColors.chocolateDark : AppColors.softAmber;
    final titleColor = isDark ? AppColors.softAmber : AppColors.chocolateDark;

    final btnBg = isDark ? AppColors.lightVanilla : AppColors.chocolateDark;
    final btnFg = isDark ? AppColors.chocolateDark : AppColors.softAmber;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconlyBold.login, size: 80, color: titleColor),
                const SizedBox(height: 16),
                Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 40),

                _buildInputSection(
                  label: "Email Address",
                  controller: _emailController,
                  hintText: "example@mail.com",
                  isDark: isDark,
                  icon: IconlyLight.message,
                ),
                const SizedBox(height: 20),

                _buildInputSection(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "********",
                  isDark: isDark,
                  isPassword: true,
                  icon: IconlyLight.lock,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: btnBg,
                      foregroundColor: btnFg,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _isLoading = true; 
                        });

                        try {
                          final userProvider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );

                          await userProvider.fetchUserInfo(
                            _emailController.text.trim(),
                          );

                          final user = userProvider.getUser;

                          if (user != null) {
                            if (_passwordController.text == user.password) {
                              Navigator.pushReplacement(
                                // ignore: use_build_context_synchronously
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RootScreen(),
                                ),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Wrong password!"),
                                ),
                              );
                            }
                          } else {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "The user with that email does not exist.",
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: ${e.toString()}")),
                          );
                        } finally {
                          setState(() {
                            _isLoading =
                                false; 
                          });
                        }
                      }
                    },
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Log in',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  style: TextButton.styleFrom(foregroundColor: titleColor),
                  onPressed: () {
                    currentUser = UserType.guest;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RootScreen()),
                    );
                  },
                  child: const Text(
                    "Continue as Guest",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),

                const SizedBox(height: 10),

                TextButton(
                  style: TextButton.styleFrom(foregroundColor: titleColor),
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
        ),
      ),
    );
  }

  Widget _buildInputSection({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required bool isDark,
    required IconData icon,
    bool isPassword = false,
  }) {
    final Color contentColor = isDark
        ? AppColors.softAmber
        : AppColors.chocolateDark;
    final Color fieldColor = isDark
        ? const Color(0xFF3E2723)
        : Colors.white.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: contentColor,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          style: TextStyle(color: contentColor),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: contentColor),
            filled: true,
            fillColor: fieldColor,
            hintText: hintText,
            hintStyle: TextStyle(color: contentColor.withValues(alpha: 0.4)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          validator: (value) =>
              value == null || value.isEmpty ? "$label is required" : null,
        ),
      ],
    );
  }
}
