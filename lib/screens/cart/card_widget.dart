import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
//import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/cart/quantity_btm_sheet.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CardWidget extends StatefulWidget {
  const CardWidget({super.key, required this.product});
  final Product product; 

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isLiked = false; // promenljiva za srce

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: FancyShimmerImage(
              //imageUrl: AppConstants.imageUrl,
              imageUrl: widget.product.imageUrl,
              height: size.height * 0.15,
              width: size.height * 0.15,
              boxFit: BoxFit.contain,
            ),
            
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      /*child: TitelesTextWidget(
                        label: "Perfume Name",
                        maxLines: 2,
                      ),*/
                      child: TitelesTextWidget(label: widget.product.name),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      icon: Icon(
                        isLiked ? IconlyBold.heart : IconlyLight.heart,
                        color: isLiked
                            ? Colors.red
                            : (isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    /*SubtitleTextWidget(
                      label: "1200 RSD",
                      color: isDark
                          ? AppColors.softAmber
                          : AppColors.chocolateDark,
                    ),*/
                    SubtitleTextWidget(label: "${widget.product.price} RSD"),
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
    );
  }
}
