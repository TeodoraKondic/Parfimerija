import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class Styles {
  static ThemeData themeData({
    required bool isDarkTheme,
    required BuildContext context,
  }) {
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
          ? AppColors.darkYellowGold
          : AppColors.lightVanilla,
      cardColor: isDarkTheme ? Colors.grey[800] : AppColors.lightVanilla,
      brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: isDarkTheme ? AppColors.lightVanilla : AppColors.chocolateDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      appBarTheme: AppBarTheme(
        iconTheme: IconThemeData(
          color: isDarkTheme ? AppColors.lightVanilla : AppColors.chocolateDark,
        ),
        backgroundColor: isDarkTheme ? AppColors.deepGold : AppColors.softAmber,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: isDarkTheme ? AppColors.lightVanilla : AppColors.chocolateDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        contentPadding: const EdgeInsets.all(10),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.transparent),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: isDarkTheme
                ? AppColors.lightVanilla
                : AppColors.chocolateDark,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Theme.of(context).colorScheme.error,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }
}
