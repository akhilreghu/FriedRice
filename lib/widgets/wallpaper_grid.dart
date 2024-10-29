import 'package:flutter/material.dart';
import '../models/wallpaper.dart';
import '../services/wallpaper_service.dart';
import 'wallpaper_card.dart';

class WallpaperGrid extends StatelessWidget {
  final String category;

  const WallpaperGrid({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Wallpaper>>(
      future: WallpaperService().getWallpapers(category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final wallpapers = snapshot.data ?? [];
        
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: wallpapers.length,
          itemBuilder: (context, index) {
            return WallpaperCard(wallpaper: wallpapers[index]);
          },
        );
      },
    );
  }
}