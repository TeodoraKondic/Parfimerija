import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/theme_data.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/providers/products_provider.dart';
import 'package:parfimerija_app/providers/theme_providers.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/screens/admin/orders/order_screen_admin.dart';
import 'package:parfimerija_app/screens/admin/perfume_management_screen.dart';
import 'package:parfimerija_app/screens/admin/users/user_screen_admin.dart';
import 'package:parfimerija_app/screens/auth/login_screen.dart';
import 'package:parfimerija_app/screens/auth/register_screen.dart';
import 'package:parfimerija_app/screens/cart/cart_screen.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- obavezno za async
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Parfimerija',
            theme: Styles.themeData(
              isDarkTheme: themeProvider.getIsDarkTheme,
              context: context,
            ),
            initialRoute: '/login',
            routes: {
              '/login': (context) => LoginScreen(
                onLoginSuccess: () {
                  Navigator.pushReplacementNamed(context, '/root');
                },
              ),
              '/register': (context) => const RegisterScreen(),
              '/root': (context) => const RootScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/search': (context) => const SearchScreen(),
              '/cart': (context) => const CartScreen(),
              '/admin_users': (context) => const UserManagementScreen(),
'/admin_perfumes': (context) => const PerfumeManagementScreen(),
'/admin_orders': (context) => const OrderManagementScreen(),

              WishlistScreen.routName: (ctx) => const WishlistScreen(),
              ViewedRecentlyScreen.routName: (ctx) =>const ViewedRecentlyScreen(),
              OrdersScreen.routName: (ctx) => const OrdersScreen(),
              AddressScreen.routName: (ctx) => const AddressScreen(),
              EditProfileScreen.routName: (context) => const EditProfileScreen(),
              ChangePasswordScreen.routName: (context) =>const ChangePasswordScreen(),
    
              
            },
          );
        },
      ),
    );
  }
}
