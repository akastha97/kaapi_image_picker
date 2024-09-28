import 'dart:convert';

/// Model class for Coffee API response.
class CoffeeModel {
  String file;

  CoffeeModel({
    required this.file,
  });

  factory CoffeeModel.fromRawJson(String str) =>
      CoffeeModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CoffeeModel.fromJson(Map<String, dynamic> json) => CoffeeModel(
        file: json["file"],
      );

  Map<String, dynamic> toJson() => {
        "file": file,
      };
}
