import 'package:flutter/material.dart';
import 'package:parfimerija_app/providers/viewed_provider.dart';
import 'package:parfimerija_app/services/assets_manager.dart';
import 'package:parfimerija_app/widgets/empty_bag.dart';
import 'package:parfimerija_app/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewedProducts = context.watch<ViewedProvider>().items;

    if (viewedProducts.isEmpty) {
      return Scaffold(
        body: EmptyBagWidget(
          imagePath: "${AssetsManager.imagePath}/bag/checkout.png",
          title: "No viewed products yet",
          subtitle: "Looks like you haven't viewed any products.",
          buttonText: "Shop now",
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
              "${AssetsManager.imagePath}/bag/checkout.png"),
        ),
        title: const TitelesTextWidget(label: "Viewed recently"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ViewedProvider>().clear();
            },
            icon: const Icon(Icons.delete_forever_rounded),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: viewedProducts.length,
        itemBuilder: (context, index) {
          final title = viewedProducts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.remove_red_eye),
              title: Text(title),
            ),
          );
        },
      ),
    );
  }
}
