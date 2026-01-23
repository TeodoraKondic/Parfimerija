import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/main.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/inner_screen/address_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/edit_profile/change_password_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/edit_profile/edit_profile_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/edit_profile/profile_header_widget.dart';
import 'package:parfimerija_app/screens/inner_screen/orders/orders_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/viewed_recently.dart';
import 'package:parfimerija_app/screens/inner_screen/wishlist.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: Image.asset(
              "${AssetsManager.imagePath}/logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            ProfileHeaderWidget(
              name: "Teodora Kondic",
              email: "primer@gmail.com",
              imagePath: "${AssetsManager.imagePath}/profile/mojaSlika.png",
              onEdit: () {
                Navigator.pushNamed(context, EditProfileScreen.routName);
              },
            ),

            const SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const TitelesTextWidget(label: "General"),
                  const SizedBox(height: 10),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
                    text: "All orders",
                    function: () {
                      Navigator.pushNamed(context, OrdersScreen.routName);
                    },
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/bag/wishlist.png",
                    text: "Wishlist",
                    function: () {
                      Navigator.pushNamed(context, WishlistScreen.routName);
                    },
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/profile/repeat.png",
                    text: "Viewed recently",
                    function: () {
                      Navigator.pushNamed(
                        context,
                        ViewedRecentlyScreen.routName,
                      );
                    },
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/address.png",
                    text: "Address",
                    function: () {
                      Navigator.pushNamed(context, AddressScreen.routName);
                    },
                  ),

                  const SizedBox(height: 20),

                  const TitelesTextWidget(label: "Security"),
                  const SizedBox(height: 10),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/profile/edit.png",
                    text: "Change Password",
                    function: () {
                      Navigator.pushNamed(context, ChangePasswordScreen.routName);
                    },
                  ),

                  const SizedBox(height: 20),

                  const TitelesTextWidget(label: "Settings"),
                  SwitchListTile(
                    title: Text(
                      themeProvider.getIsDarkTheme
                          ? "Dark Theme"
                          : "Light Theme",
                    ),
                    value: themeProvider.getIsDarkTheme,
                    onChanged: (value) {
                      themeProvider.setDarkTheme(themeValue: value);
                    },
                  ),

                  const SizedBox(height: 20),

                
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeProvider.getIsDarkTheme
                            ? AppColors.chocolateDark
                            : AppColors.softAmber,
                        foregroundColor: themeProvider.getIsDarkTheme
                            ? AppColors.softAmber
                            : AppColors.chocolateDark,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        currentUser = UserType.guest;
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      label: const Text("Logout"),
                      icon: const Icon(IconlyLight.logout),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.imagePath,
    required this.text,
    required this.function,
  });

  final String imagePath, text;
  final VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: function,
      title: SubtitleTextWidget(label: text),
      leading: Image.asset(imagePath, height: 34),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}

