import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/const/app_colors.dart';

class HeartButtonWidget extends StatefulWidget {
  const HeartButtonWidget({
    super.key,
    this.bkgColor = Colors.transparent,
    this.size = 20, 
  });

  final Color bkgColor;
  final double size;

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () {
          setState(() {
            isLiked = !isLiked;
          });
        },
        icon: Icon(
          isLiked ? IconlyBold.heart : IconlyLight.heart, // Puno srce kad je lajkovano
          size: widget.size,
          color: isLiked
              ? Colors.red
              : (isDark ? AppColors.lightVanilla : AppColors.chocolateDark),
        ),
      ),
    );
  }
}

