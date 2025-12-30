import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
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
        leading: Image.asset("${AssetsManager.imagePath}/logo.png"),
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Visibility(
              visible: false,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitelesTextWidget(
                  label: "Pleae login to have unlimited access",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.surface,
                        width: 3,
                      ),
                      color: Theme.of(context).cardColor,
                      image: DecorationImage(
                        image: NetworkImage(
                          "https://wallpapers.com/images/featured/cute-aesthetic-profile-pictures-pjfl391j3q0f7rlz.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
        
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //ovde ide ime i prezime
                      TitelesTextWidget(label: ""),
                      const SizedBox(width: 4),
                      //ovde ide kao email
                      SubtitleTextWidget(label: ""),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitelesTextWidget(label: "General"),
                  const SizedBox(height: 10),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
                    text: "All orders",
                    function: () {},
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/bag/wishlist.png",
                    text: "Wishlist",
                    function: () {},
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/profile/repeat.png",
                    text: "Viewed recently",
                    function: () {},
                  ),
                  CustomListTile(
                    imagePath: "${AssetsManager.imagePath}/address.png",
                    text: "Address",
                    function: () {},
                  ),
                  SizedBox(height: 10),
                  const TitelesTextWidget(label: "Settings"),
                  const SizedBox(height: 10),
                  SwitchListTile(
                title: Text(
                  themeProvider.getIsDarkTheme ? "Dark Theme" : "Light Theme",
                ),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) {
                  themeProvider.setDarkTheme(themeValue: value);
                },
              ),
                  Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightCardColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                      onPressed: (){}, 
                      label: const Text("Logout"),
                      icon: const Icon(IconlyLight.logout)
                    ),
                  ),
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
  final Function function;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      title: SubtitleTextWidget(label: text),
      leading: Image.asset( imagePath, height: 34,),
      trailing: const Icon(IconlyLight.arrowRight2),
    );
  }
}
    