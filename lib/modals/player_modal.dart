
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'player_modal.g.dart';

@HiveType(typeId: 1)
class Player extends Equatable {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? first_name;
  @HiveField(2)
  final String? last_name;
  @HiveField(3)
  final String? position;
  @HiveField(4)
  final int? height_feet;
  @HiveField(5)
  final int? height_inches;
  @HiveField(6)
  final int? weight_pounds;
  @HiveField(7)
  final String? abbreviation;

  const Player(
      this.id,
      this.first_name,
      this.last_name,
      this.position,
      this.height_feet,
      this.height_inches,
      this.weight_pounds,
      this.abbreviation,
      );

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
        json['id'],
        json["first_name"],
        json["last_name"],
        json["position"],
        json["height_feet"],
        json["height_inches"],
        json["weight_pounds"],
        json["abbreviation"]
    );}

  factory Player.fromDao(Map<String, dynamic> json) {
    return Player(
      json['id'],
      json["first_name"],
      json["last_name"],
      json["position"],
      json["height_feet"],
      json["height_inches"],
      json["weight_pounds"],
      json["abbreviation"],
    );
  }

  Map<String, Object?> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "position": position,
      "height_feet": height_feet,
      "height_inches": height_inches,
      "weight_pounds": weight_pounds,
      "abbreviation": abbreviation,
    };
  }

  @override
  List<Object?> get props => [
    id,
    first_name,
    last_name,
    position,
    height_feet,
    height_inches,
    weight_pounds,
    abbreviation,
  ];
}