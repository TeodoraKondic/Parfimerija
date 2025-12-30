import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SubtitleTextWidget(label: "Ćaooo"),
            const TitelesTextWidget(label: "Da li hoćeš da promeniš boju?"),
            SwitchListTile(
              title: Text(
                themeProvider.getIsDarkTheme ? "Dark Theme" : "Light Theme",
              ),
              value: themeProvider.getIsDarkTheme,
              onChanged: (value) {
                themeProvider.setDarkTheme(themeValue: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}