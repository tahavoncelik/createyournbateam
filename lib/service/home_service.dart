import 'dart:convert';
import 'package:createyournbateam/modals/player_modal.dart';
import '../modals/team_modal.dart';
import 'package:http/http.dart' as http;

class HomeService {

  Future<List<Team>> getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    if (response.statusCode == 200) {
      var body = response.body;
      final teamMaptoList = (jsonDecode(body)['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      final teams = <Team>[];
      for (final eachTeam in teamMaptoList) {
        teams.add(Team.fromJson(eachTeam));
      }
      print("1 ${teams.length}" );
      return teams;
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<List<Player>> getPlayers() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/players'));

    if (response.statusCode == 200) {
      var body = response.body;
      final playerMaptoList = (jsonDecode(body)['data'] as List<dynamic>).cast<Map<String, dynamic>>();
      final players = <Player>[];
      for (var eachPlayer in playerMaptoList) {
        players.add(Player.fromJson(eachPlayer));
      }
      return players;
    } else {
      throw Exception('Failed to load players');
    }
  }
}
