import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';
//import 'package:mobilne_projekat/widgets/subtitle_text.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class CategoryRoundedWidget extends StatelessWidget {
  const CategoryRoundedWidget({
    super.key,
    required this.image,
    required this.name,
  });
  final String image, name;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Boja teksta prema temi
    final textColor = themeProvider.getIsDarkTheme
        ? AppColors.lightVanilla
        : AppColors.chocolateDark;

    // Opcionalno: boja pozadine kruga
    final circleBgColor = themeProvider.getIsDarkTheme
        ? AppColors.chocolateDark.withValues(alpha:0.2)
        : AppColors.softAmber..withValues(alpha:0.2);

    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: circleBgColor,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(8),
          child: Image.asset(image, fit: BoxFit.contain),
        ),
        const SizedBox(height: 5),
        SubtitleTextWidget(
          label: name,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ],
    );
  }
}
