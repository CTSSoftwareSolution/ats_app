import 'dart:io';

class InspectionImageModel {
  final int id;
  final String title;
  final String subtitle;
  final bool isRequired;


  InspectionImageModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.isRequired,

  });

  factory InspectionImageModel.fromJson(Map<String, dynamic> json) {
    return InspectionImageModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      isRequired: json['isRequired'],

    );
  }
}
