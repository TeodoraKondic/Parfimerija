import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_consts.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';


class OrdersWidget extends StatelessWidget {
  
  final Map<String, dynamic> orderData;

  const OrdersWidget({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        children: [
         
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: FancyShimmerImage(
              height: size.width * 0.25,
              width: size.width * 0.25,
            
              imageUrl: orderData['imageUrl'] ?? AppConstants.imageUrl,
            ),
          ),
          
          Flexible(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: TitelesTextWidget(
                          label: orderData['productName'] ?? 'Unknown perfume',
                          maxLines: 2,
                          fontSize: 15,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  
                  // CENA
                  Row(
                    children: [
                      const TitelesTextWidget(label: 'Price: ', fontSize: 15),
                      Flexible(
                        child: SubtitleTextWidget(
                          label: "${orderData['priceTotal']} RSD",
                          fontSize: 15,
                          color: Theme.of(context).textTheme.titleLarge?.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  
                  // KOLIČINA
                  SubtitleTextWidget(
                    label: "Quantity: ${orderData['quantity']}", 
                    fontSize: 15
                  ),
                  const SizedBox(height: 5),
                  
                
                  Row(
                    children: [
                      const TitelesTextWidget(label: 'Status: ', fontSize: 14),
                      SubtitleTextWidget(
                        label: "${orderData['status']}",
                        fontSize: 14,
                        color: _getStatusColor(orderData['status']),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mala pomoćna funkcija da boja statusa bude različita
  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }
}