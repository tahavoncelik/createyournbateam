import 'package:createyournbateam/bloc/home_bloc/home_event.dart';
import 'package:createyournbateam/bloc/home_bloc/home_state.dart';
import 'package:createyournbateam/modals/team_modal.dart';
import 'package:createyournbateam/service/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../modals/player_modal.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final HomeRepository? homeRepository;

  HomeBloc({this.homeRepository}) : super(const HomeInitial()){
    on<GetTeamsList>((event, emit) async {
      try{
        emit(const HomeLoading());
        final List<Team> teamsList = await homeRepository?.getTeams();
        print(teamsList.length);
        emit(HomeLoaded(teamsList: teamsList));
      } on NetworkError{
        emit(const HomeError(error: "Fetch data failed"));
      }
      catch (e){
        emit(HomeError(error: e.toString()));
      }
    });
  }
}

class PlayerBloc extends Bloc<PlayerEvent, PlayerState>{
  final HomeRepository? homeRepository;

  PlayerBloc({this.homeRepository}):super(const PlayerInitial()){
    on<GetPlayerList>((event, emit) async {
      try{
        emit(const PlayerLoading());
        final List<Player> playerList = await homeRepository?.getPlayers();
        emit(PlayerLoaded(playerList: playerList));
      } on NetworkError{
        emit(const PlayerError(error: "Fetch data failed"));
      }
      catch (e){
        emit(PlayerError(error: e.toString()));
      }
    });
  }
}