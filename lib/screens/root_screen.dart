import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/screens/admin/admin_screen.dart';
import 'package:parfimerija_app/screens/cart/cart_screen.dart';
import 'package:parfimerija_app/screens/home_screen.dart';
import 'package:parfimerija_app/screens/profile_screen.dart';
import 'package:parfimerija_app/screens/search_screen.dart';

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
    return Scaffold(
      body: PageView(controller: controller, children: screens),
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
        destinations: const [
          NavigationDestination(
            icon: Icon(IconlyLight.home),
            selectedIcon: Icon(IconlyBold.home),
            label: "Home",
          ),

          NavigationDestination(
            icon: Icon(IconlyLight.search),
            selectedIcon: Icon(IconlyBold.search),
            label: "Search",
          ),

          NavigationDestination(
            icon: Icon(IconlyLight.profile),
            selectedIcon: Icon(IconlyBold.profile),
            label: "Profile",
          ),

          NavigationDestination(
            icon: Badge(
              backgroundColor:
                  AppColors.darkScaffoldColor, //u indeksu pise mali broj
              label: Text("5"),
              child: Icon(IconlyLight.bag2),
            ),
            selectedIcon: Icon(IconlyBold.bag2),
            label: "Cart",
          ),
          NavigationDestination(
            
            icon: Icon(Icons.admin_panel_settings),
            selectedIcon: Icon(Icons.admin_panel_settings),

            label: "Admin",
          ),
        ],
      ),
    );
  }
}

