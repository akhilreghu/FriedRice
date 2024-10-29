class Wallpaper {
  final String id;
  final String thumbnailUrl;
  final String fullUrl;
  final String title;
  final String category;
  final int downloads;
  final int likes;

  Wallpaper({
    required this.id,
    required this.thumbnailUrl,
    required this.fullUrl,
    required this.title,
    required this.category,
    required this.downloads,
    required this.likes,
  });

  factory Wallpaper.fromJson(Map<String, dynamic> json) {
    return Wallpaper(
      id: json['id'],
      thumbnailUrl: json['thumbnailUrl'],
      fullUrl: json['fullUrl'],
      title: json['title'],
      category: json['category'],
      downloads: json['downloads'],
      likes: json['likes'],
    );
  }
}