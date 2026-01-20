/*import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/cart/quantity_btm_sheet.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;
    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FancyShimmerImage(
                  imageUrl: AppConstants.imageUrl,
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                  boxFit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: TitelesTextWidget(
                            label: "Perfume" * 1,
                            maxLines: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.clear,
                                color: isDark
                                    ? AppColors.softAmber
                                    : AppColors.chocolateDark,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(IconlyLight.heart,
                              color: isDark
                                    ? AppColors.softAmber
                                    : AppColors.chocolateDark,),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SubtitleTextWidget(
                          label: "1200 RSD",
                          color: isDark
                              ? AppColors.softAmber
                              : AppColors.chocolateDark,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return const QuantityBottomSheetWidget();
                              },
                            );
                          },
                          icon: const Icon(IconlyLight.arrowDown2),
                          label: Text("Quantity: 5",style: TextStyle(color: isDark
                                  ? AppColors.softAmber
                                  : AppColors.chocolateDark,),),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                width: 1,
                                color: isDark
                                    ? AppColors.softAmber
                                    : AppColors.chocolateDark),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/cart/quantity_btm_sheet.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isLiked = false; // promenljiva za srce

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return FittedBox(
      child: IntrinsicWidth(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: FancyShimmerImage(
                  imageUrl: AppConstants.imageUrl,
                  height: size.height * 0.2,
                  width: size.height * 0.2,
                  boxFit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 10),
              IntrinsicWidth(
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.6,
                          child: TitelesTextWidget(
                            label: "Perfume",
                            maxLines: 2,
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              style: IconButton.styleFrom(elevation: 10),
                              onPressed: () {
                                setState(() {
                                  isLiked = !isLiked;
                                });
                              },
                              icon: Icon(
                                isLiked
                                    ? IconlyBold.heart
                                    : IconlyLight
                                          .heart, // Puno srce kad je lajkovano
                                color: isLiked
                                    ? Colors.red
                                    : (isDark
                                          ? AppColors.lightVanilla
                                          : AppColors.chocolateDark),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SubtitleTextWidget(
                          label: "1200 RSD",
                          color: isDark
                              ? AppColors.softAmber
                              : AppColors.chocolateDark,
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await showModalBottomSheet(
                              backgroundColor: Theme.of(
                                context,
                              ).scaffoldBackgroundColor,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return const QuantityBottomSheetWidget();
                              },
                            );
                          },
                          icon: Icon(
                            IconlyLight.arrowDown2,
                            color: isDark
                                ? AppColors.softAmber
                                : AppColors.chocolateDark,
                          ),
                          label: Text(
                            "Quantity: 5",
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.softAmber
                                  : AppColors.chocolateDark,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: isDark
                                  ? AppColors.softAmber
                                  : AppColors.chocolateDark,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
