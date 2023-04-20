import 'package:get_it/get_it.dart';

import 'config.dart';

class PeopleModel {
  final String name;
  final int peopleId;
  final String? profilePath;
  final String? job;

  PeopleModel({
    required this.name,
    required this.peopleId,
    this.profilePath,
    this.job,
  });

  factory PeopleModel.fromJson(Map<String, dynamic> json) {
    return PeopleModel(
      name: json['name'],
      peopleId: json['id'],
      profilePath: json['profile_path'],
      job: json['job'] ?? "",
    );
  }

  String profileUrl(){
    final AppConfig appConfig = GetIt.instance.get<AppConfig>();
    return '${appConfig.baseImageApiUrl}w185$profilePath';
  }
}
