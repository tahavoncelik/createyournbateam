import 'package:createyournbateam/screens/home_or_team_page.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'modals/player_modal.dart';


Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PlayerAdapter());
  await Hive.openBox<Player>('myTeam');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeOrTeamPage(),
    );
  }
}