import 'package:createyournbateam/screens/home_page.dart';
import 'package:createyournbateam/screens/team_page.dart';
import 'package:flutter/material.dart';

class HomeOrTeamPage extends StatefulWidget {
  const HomeOrTeamPage({super.key});

  @override
  State<HomeOrTeamPage> createState() => _HomeOrTeamPageState();
}

class _HomeOrTeamPageState extends State<HomeOrTeamPage> {
  bool showBooklistPage = true;

  void togglePages(){
    setState(() {
      showBooklistPage = !showBooklistPage;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showBooklistPage){
      return HomePage(onTap: togglePages);
    }
    else{
      return TeamPage(onTap: togglePages);
    }
  }
  }
