class ImagesModel {
  final String? backdropFilePath;
  final String? postersFilePath;
  final String? logoFilePath;

  ImagesModel({
    this.backdropFilePath,
    this.logoFilePath,
    this.postersFilePath,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) {
    return ImagesModel(
      backdropFilePath: json['backdrops']['file_path'],
      logoFilePath: json['logos']['file_path'],
      postersFilePath: json['posters']['file_path'],
    );
  }
}

class VideoModel {
  final String? type;
  final String? site;
  final String key;
  final String? name;

  VideoModel({
    required this.key,
    this.site,
    this.type,
    this.name,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json){
    return VideoModel(
      site: json['site'],
      type: json['type'],
      key: json['key'],
      name: json['name'],
    );
  }
}
