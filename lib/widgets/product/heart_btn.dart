
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/models/product.dart';
import 'package:parfimerija_app/providers/wishlist_provider.dart';

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
  @override
  Widget build(BuildContext context) {

    bool isDark = Provider.of<ThemeProvider>(context).getIsDarkTheme;
    
   
    final wishlistProvider = Provider.of<WishlistProvider>(context);
   
    final product = Provider.of<Product>(context);

 
    bool isInWishlist = wishlistProvider.isProductInWishlist(productId: product.id);

    return Container(
      decoration: BoxDecoration(
        color: widget.bkgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        style: IconButton.styleFrom(elevation: 10),
        onPressed: () {
        
          wishlistProvider.addOrRemoveFromWishlist(product: product);
        },
        icon: Icon(
         
          isInWishlist ? IconlyBold.heart : IconlyLight.heart, 
          size: widget.size,
          color: isInWishlist
              ? Colors.red
              : (isDark ? AppColors.lightVanilla : AppColors.chocolateDark),
        ),
      ),
    );
  }
}