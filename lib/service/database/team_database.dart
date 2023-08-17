
import 'package:createyournbateam/modals/player_modal.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TeamDatabase{

  // Open the box
  var myDatabase = Hive.box<Player>('myTeam');

 // Add To Database
 Future<void> addToTeam(Player player) async {
    if(myDatabase.toMap().containsValue(player)){
      print("Already added");
    }
    else{
      await myDatabase.add(player);
    }
  }

   // Delete From Database
 Future<void> removeFromTeam(Player player) async {
    final index = myDatabase.values.toList().indexWhere((item) => item.id == player.id);
    if (index != -1) {
      await myDatabase.deleteAt(index);
    } else {
      print("Player not found in the team");
    }
  }

  // Get Database
  Future<List<Player>> getTeam() async {
    final myTeam = myDatabase.values.toList();
    return myTeam;
  }
}