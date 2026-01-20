import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class EmptyBagWidget extends StatelessWidget {
  const EmptyBagWidget({
    super.key,
    this.imagePath,
    this.subtitle,
    this.title,
    this.buttonText,
  });

  // ignore: prefer_typing_uninitialized_variables, strict_top_level_inference
  final imagePath, title, subtitle, buttonText;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 230),
        Image.asset(
          imagePath,
          width: double.infinity,
          height: size.height * 0.20,
        ),
        const SizedBox(height: 20),
        TitelesTextWidget(label: title),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: SubtitleTextWidget(label: subtitle)),
        ),
        ElevatedButton(
          onPressed: () {
            // ovde ide šta dugme treba da radi, npr. navigacija
            // ignore: avoid_print
            print("Shop now");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Provider.of<ThemeProvider>(context).getIsDarkTheme
                ? AppColors.chocolateDark
                : AppColors.softAmber,
            foregroundColor: Provider.of<ThemeProvider>(context).getIsDarkTheme
                ? AppColors.softAmber
                : AppColors.chocolateDark,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }
}
