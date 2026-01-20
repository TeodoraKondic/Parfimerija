import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';

class CartBottomSheetWeidget extends StatelessWidget {
  const CartBottomSheetWeidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: const Border(top: BorderSide(width: 1, color: Colors.grey)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: kBottomNavigationBarHeight + 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FittedBox(
                      child: TitelesTextWidget(
                        label: "Total (5 products/10 items)",
                      ),
                    ),
                    SubtitleTextWidget(
                      label: "2200 RSD",
                      color: isDark
                          ? AppColors.softAmber
                          : AppColors.chocolateDark,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/checkout");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? AppColors.softAmber : AppColors.chocolateDark,
                  foregroundColor:
                      isDark ? AppColors.chocolateDark : AppColors.softAmber,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Checkout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
