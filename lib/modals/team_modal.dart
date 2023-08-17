import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

class Team extends Equatable {
  @HiveField(0)
  final String? abbreviation;
  @HiveField(1)
  final String? city;
  @HiveField(2)
  final int? id;
  @HiveField(3)
  final String? name;



  const Team(
      this.abbreviation,
      this.city,
      this.id,
      this.name,
      );

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
        json['abbreviation'],
        json["city"],
        json["id"],
        json["name"],
    );}

  factory Team.fromDao(Map<String, dynamic> json) {
    return Team(
      json['abbreviation'],
      json["city"],
      json["id"],
      json["name"],
    );
  }

  Map<String, Object?> toJson() {
    return {
      "abbreviation": abbreviation,
      "city": city,
      "id": id,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [
    abbreviation,
    city,
    id,
    name,
  ];
}