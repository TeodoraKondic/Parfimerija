import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/providers/cart_provider.dart';
import 'package:parfimerija_app/providers/user_provider.dart';
import 'package:parfimerija_app/screens/admin/admin_screen.dart';
import 'package:parfimerija_app/screens/cart/cart_screen.dart';
import 'package:parfimerija_app/screens/home_screen.dart';
import 'package:parfimerija_app/screens/profile_screen.dart';
import 'package:parfimerija_app/screens/search_screen.dart';
import 'package:parfimerija_app/widgets/LoginRequiredWidget';
import 'package:provider/provider.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => RootScreenState();
}

class RootScreenState extends State<RootScreen> {
  late List<Widget> screens;
  int currentScreen = 0; //da se prikaze prvi skrin iz liste
  late PageController controller;

  @override
  void initState() {
    super.initState();
    screens = const [
      HomeScreen(),
      SearchScreen(),
      ProfileScreen(),
      CartScreen(),
      AdminScreen(),
    ];
    controller = PageController(initialPage: currentScreen);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
final user = userProvider.getUser;

List<Widget> screens = [
  const HomeScreen(),  
  const SearchScreen(), 
  
  user == null 
    ? const LoginRequiredWidget(text: "Please login to view your profile.") 
    : const ProfileScreen (),
    
  user == null 
    ? const LoginRequiredWidget(text: "Please login to view your cart.") 
    : const CartScreen(),

user?.role == 'admin'
        ? const AdminScreen()
        : const LoginRequiredWidget(text: "Access denied. Only administrators can view this section."),
    ];
    return Scaffold(
      body: PageView(controller: controller,physics: const NeverScrollableScrollPhysics(), children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreen,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        height:
            kBottomNavigationBarHeight, 
        onDestinationSelected: (index) {
          setState(() {
            currentScreen = index;
          });
          controller.jumpToPage(currentScreen);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(IconlyLight.home),
            selectedIcon: Icon(IconlyBold.home),
            label: "Home",
          ),

          const NavigationDestination(
            icon: Icon(IconlyLight.search),
            selectedIcon: Icon(IconlyBold.search),
            label: "Search",
          ),

          const NavigationDestination(
            icon: Icon(IconlyLight.profile),
            selectedIcon: Icon(IconlyBold.profile),
            label: "Profile",
          ),

          NavigationDestination(
          icon: cartProvider.items.isEmpty 
            ? const Icon(IconlyLight.bag2) 
            : Badge(
                backgroundColor: AppColors.darkScaffoldColor,
                label: Text(cartProvider.items.length.toString()), 
                child: const Icon(IconlyLight.bag2),
              ),
          selectedIcon: const Icon(IconlyBold.bag2),
          label: "Cart",
        ),
          const NavigationDestination(
            
            icon: Icon(Icons.admin_panel_settings),
            selectedIcon: Icon(Icons.admin_panel_settings),

            label: "Admin",
          ),
        ],
      ),
    );
  }
}

