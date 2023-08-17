import 'dart:async';

import '../../modals/player_modal.dart';
import '../../service/database/team_database.dart';


class TeamBloc {
  final TeamDatabase _teamDatabase;

  TeamBloc(this._teamDatabase) {
    _eventStreamController.stream.listen(_raFavs);
  }

  final StreamController<TeamState> _teamStreamController =
  StreamController.broadcast();
  StreamSink<TeamState> get _stateSink => _teamStreamController.sink;
  Stream<TeamState> get stream =>
      _teamStreamController.stream.asBroadcastStream();

  final StreamController<TeamEvent> _eventStreamController = StreamController();

  // Add/Remove Team
  Future<void> _raFavs(TeamEvent event) async {
    if (event is AddTeamFetchedEvent) {
      await _teamDatabase.addToTeam(event.player);
      final yourTeamList = await _teamDatabase.getTeam();
      _stateSink.add(TeamState(yourTeamList));
    }
    if (event is RemoveTeamFetchedEvent) {
      await _teamDatabase.removeFromTeam(event.player);
      final yourTeamList = await _teamDatabase.getTeam();
      _stateSink.add(TeamState(yourTeamList));
    }
  }

  void addTeamFetchedEvent({required Player player}) {
    _eventStreamController.add(AddTeamFetchedEvent(player));
  }

  void getTeam() async {
    final yourTeamList = await _teamDatabase.getTeam();
    _stateSink.add(TeamState(yourTeamList));
  }

  void removeTeamFetchedEvent({required Player player}) {
    _eventStreamController.add(RemoveTeamFetchedEvent(player));
  }

  void dispose() {
    _teamStreamController.close();
  }
}

class TeamState {
  final List<Player> yourTeamList;
  TeamState(this.yourTeamList);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamState && other.yourTeamList == yourTeamList);
  }

  @override
  int get hashCode => yourTeamList.hashCode;
}

abstract class TeamEvent {
  const TeamEvent();
}

class TeamFetchedEvent extends TeamEvent {
  final Player player;
  const TeamFetchedEvent(
      this.player,
      );

  // To support value equality
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TeamFetchedEvent && other.player == player);
  }

  @override
  int get hashCode => player.hashCode;
}

class AddTeamFetchedEvent extends TeamEvent {
  final Player player;

  const AddTeamFetchedEvent(
      this.player,
      );

  // To support value equality
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AddTeamFetchedEvent && other.player == player);
  }

  @override
  int get hashCode => player.hashCode;
}

class RemoveTeamFetchedEvent extends TeamEvent {
  final Player player;
  const RemoveTeamFetchedEvent(
      this.player,
      );

  // To support value equality
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RemoveTeamFetchedEvent && other.player == player);
  }

  @override
  int get hashCode => player.hashCode;
}