import 'package:equatable/equatable.dart';

import '../../modals/player_modal.dart';
import '../../modals/team_modal.dart';

abstract class HomeState extends Equatable{
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState{
  const HomeInitial();
}

class HomeLoading extends HomeState{
  const HomeLoading();
}

class HomeLoaded extends HomeState{
  final List<Team> teamsList;
  const HomeLoaded({required this.teamsList});

  @override
  List<Object> get props => [teamsList];
}

class HomeError extends HomeState{
  final String error;
  const HomeError({required this.error});

  @override
  List<Object> get props => [error];
}


abstract class PlayerState extends Equatable{
  const PlayerState();
  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState{
  const PlayerInitial();
}

class PlayerLoading extends PlayerState{
  const PlayerLoading();
}

class PlayerLoaded extends PlayerState{
  final List<Player> playerList;
  const PlayerLoaded({required this.playerList});

  @override
  List<Object> get props => [playerList];
}

class PlayerError extends PlayerState{
  final String error;
  const PlayerError({required this.error});

  @override
  List<Object> get props => [error];
}

