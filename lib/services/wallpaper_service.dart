import 'dart:io';
import 'dart:convert';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/wallpaper.dart';

class WallpaperService {
  static const String _pexelsApiKey = 'YOUR_PEXELS_API_KEY_HERE'; // Replace with your Pexels API key
  static const String _baseUrl = 'https://api.pexels.com/v1';

  Future<List<Wallpaper>> getWallpapers(String category) async {
    try {
      final String endpoint;
      
      switch (category) {
        case 'featured':
          endpoint = '$_baseUrl/curated';
          break;
        case 'latest':
          endpoint = '$_baseUrl/curated'; // Pexels doesn't have a latest endpoint, using curated
          break;
        case 'popular':
          endpoint = '$_baseUrl/search?query=popular&per_page=30';
          break;
        default:
          endpoint = '$_baseUrl/curated';
      }

      final response = await http.get(
        Uri.parse(endpoint),
        headers: {
          'Authorization': _pexelsApiKey,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> photos = data['photos'];
        
        return photos.map((photo) => Wallpaper(
          id: photo['id'].toString(),
          thumbnailUrl: photo['src']['medium'],
          fullUrl: photo['src']['original'],
          title: photo['alt'] ?? 'Untitled',
          category: category,
          downloads: 0, // Pexels doesn't provide this info
          likes: 0, // Pexels doesn't provide this info
        )).toList();
      } else {
        throw Exception('Failed to load wallpapers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<bool> downloadWallpaper(Wallpaper wallpaper) async {
    try {
      final response = await http.get(
        Uri.parse(wallpaper.fullUrl),
        headers: {
          'Authorization': _pexelsApiKey,
        },
      );
      
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/${wallpaper.id}.jpg';
      
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return true;
    } catch (e) {
      print('Error downloading wallpaper: $e');
      return false;
    }
  }

  Future<bool> setWallpaper(Wallpaper wallpaper) async {
    try {
      final response = await http.get(
        Uri.parse(wallpaper.fullUrl),
        headers: {
          'Authorization': _pexelsApiKey,
        },
      );
      
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/temp_wallpaper.jpg';
      
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      
      final result = await WallpaperManager.setWallpaperFromFile(
        filePath,
        WallpaperManager.HOME_SCREEN,
      );
      
      return result;
    } catch (e) {
      print('Error setting wallpaper: $e');
      return false;
    }
  }
}