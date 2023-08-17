import 'package:createyournbateam/service/home_service.dart';


class HomeRepository{
  final HomeService _homeService = HomeService();

  Future getTeams(){
    return _homeService.getTeams();
  }

  Future getPlayers(){
    return _homeService.getPlayers();
  }
}

class NetworkError extends Error{}