import 'package:flutter/material.dart';
import 'package:parfimerija_app/const/app_colors.dart';
import 'package:parfimerija_app/widgets/subtitle_text.dart';
import 'package:parfimerija_app/widgets/title_text.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String email;
  final String imagePath;
  final VoidCallback onEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.email,
    required this.imagePath,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.surface,
                    width: 1,
                  ),
                  color: Theme.of(context).cardColor,
                  image: DecorationImage(
                    image: imagePath.startsWith('http') 
                        ? NetworkImage(imagePath) as ImageProvider
                        : AssetImage(imagePath) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: AppColors.softAmber,
                    child: const Icon(
                      Icons.edit,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
         Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitelesTextWidget(
                label: name,
              ),
              const SizedBox(height: 4),
              SubtitleTextWidget(
                label: email,
              ),
            ],
          ),
        ),
        ],
      ),
    );
  }
}
