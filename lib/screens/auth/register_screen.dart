import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController(); //

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(IconlyBold.addUser, size: 80, color: titleColor),
                const SizedBox(height: 16),
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 40),

                _buildInputSection(
                  label: "Full Name",
                  controller: _nameController,
                  hintText: "Enter your name",
                  isDark: isDark,
                  icon: IconlyLight.profile,
                ),
                const SizedBox(height: 16),

                _buildInputSection(
                  label: "Email Address",
                  controller: _emailController,
                  hintText: "example@mail.com",
                  isDark: isDark,
                  icon: IconlyLight.message,
                ),
                const SizedBox(height: 16),

                _buildInputSection(
                  label: "Password",
                  controller: _passwordController,
                  hintText: "Min. 5 characters",
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
                         try {
                          
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );

                          final User? user = credential.user;
                          if (user == null) return;
                          final String uid = user.uid;

                         
                          await FirebaseFirestore.instance
                              .collection("korisnici")
                              .doc(uid)
                              .set({
                                'uid': uid,
                                'name': _nameController.text.trim(),
                                'email': _emailController.text.trim(),
                                'password': _passwordController.text.trim(),
                                'role': 'user',
                                'userImage': '',
                                'phoneNumber': '', 
                                'address': '',
                                'createdAt': Timestamp.now(),
                              });

                          
                          if (!mounted) return;
                          final userProvider = Provider.of<UserProvider>(
                            context,
                            listen: false,
                          );
                          await userProvider.fetchUserInfo(
                            _emailController.text.trim(),
                          );

                          
                          if (!mounted) return;
                          Navigator.pushReplacementNamed(context, '/root');
                        } on FirebaseAuthException catch (e) {
                          if (!mounted)
                            return; 

                          String message = "An error occurred";
                          if (e.code == 'email-already-in-use') {
                            message = "The email address is already in use.";
                          } else if (e.code == 'weak-password') {
                            message = "The password provided is too weak.";
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(foregroundColor: titleColor),
                  child: const Text("Already have an account? Sign in"),
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
          validator: (value) {
            if (value == null || value.isEmpty) return "$label is required";
            if (label == "Email Address" && !value.contains("@"))
              return "Invalid email";
            if (label == "Password" && value.length < 6)
              return "Password too short";
            return null;
          },
        ),
      ],
    );
  }
}
