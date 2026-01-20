import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/theme_data.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/screens/auth/login_screen.dart';
import 'package:parfimerija_app/screens/auth/register_screen.dart';
import 'package:parfimerija_app/screens/cart/checkout_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/address_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/edit_profile/change_password_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/edit_profile/edit_profile_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/orders/orders_screen.dart';
import 'package:parfimerija_app/screens/inner_screen/viewed_recently.dart';
import 'package:parfimerija_app/screens/inner_screen/wishlist.dart';
import 'package:parfimerija_app/screens/root_screen.dart';
import 'package:parfimerija_app/screens/search_screen.dart';
import 'package:provider/provider.dart';
enum UserType {
  guest,
  user,
  admin,
}

UserType currentUser = UserType.guest;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Parfimerija',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            //home: const RootScreen(),
            //home: const LoginScreen(),
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(
                onLoginSuccess: () {
                  // Šta se desi kad se korisnik uloguje
                  Navigator.pushReplacementNamed(context, '/root');
                },
              ),
              '/register': (context) => const RegisterScreen(),
              '/root': (context) => const RootScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/search': (context) => const SearchScreen(),


              WishlistScreen.routName: (ctx) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (ctx) =>const ViewedRecentlyScreen(),
              OrdersScreen.routName: (ctx) => const OrdersScreen(),
              AddressScreen.routName: (ctx) => const AddressScreen(),
              EditProfileScreen.routName: (context) => const EditProfileScreen(),
              ChangePasswordScreen.routName: (context) =>const ChangePasswordScreen(),
              //SearchScreen.routName: (context) => const SearchScreen()
              
            },
          );
        },
      ),
    );
  }
}
