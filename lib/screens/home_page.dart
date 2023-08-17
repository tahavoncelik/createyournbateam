import 'package:createyournbateam/bloc/home_bloc/home_bloc.dart';
import 'package:createyournbateam/bloc/home_bloc/home_event.dart';
import 'package:createyournbateam/bloc/home_bloc/home_state.dart';
import 'package:createyournbateam/bloc/team_bloc/team_bloc.dart';
import 'package:createyournbateam/service/database/team_database.dart';
import 'package:createyournbateam/service/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

final client = Client();
final homeBloc = HomeBloc();
final playerBloc = PlayerBloc();
final teamBloc = TeamBloc(TeamDatabase());

class HomePage extends StatefulWidget {
  final Function()? onTap;
  const HomePage({super.key, this.onTap});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => HomeBloc(homeRepository: HomeRepository()),
      child: BlocProvider<PlayerBloc>(
        create: (context) => PlayerBloc(homeRepository: HomeRepository()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.black, Color(0xffC9082A)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const TitleText(),
                  IconButton(
                      onPressed: widget.onTap,
                      icon: const Icon(
                        Icons.sports_basketball,
                        color: Colors.orange,
                        size: 50,
                      )),
                  const PopularPlayers(),
                  const AllTeams(),
                  SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      width: MediaQuery.sizeOf(context).width,
                      child: const AllPlayers()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleText extends StatefulWidget {
  const TitleText({super.key});

  @override
  State<TitleText> createState() => _TitleTextState();
}

class _TitleTextState extends State<TitleText> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          child: const Text(
            "Create Your NBA Team",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w100,
            ),
          ),
        ),
        const Divider(
          height: 1,
          thickness: 2,
          indent: 50,
          endIndent: 50,
          color: Colors.white,
        )
      ],
    );
  }
}

class PopularPlayers extends StatefulWidget {
  const PopularPlayers({super.key});

  @override
  State<PopularPlayers> createState() => _PopularPlayersState();
}

class _PopularPlayersState extends State<PopularPlayers> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 600,
              height: 230,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '"I’ve missed more than 9000 shots in my career. I’ve lost almost 300 games. 26 times, I’ve been trusted to take the game winning shot and missed. I’ve failed over and over and over again in my life. And that is why I succeed."',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Divider(
                      height: 15,
                      thickness: 0.5,
                      indent: 50,
                      endIndent: 50,
                      color: Colors.white,
                    ),
                    Text(
                      "MICHAEL JORDAN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class AllTeams extends StatefulWidget {
  const AllTeams({super.key});

  @override
  State<AllTeams> createState() => _AllTeamsState();
}

class _AllTeamsState extends State<AllTeams> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetTeamsList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeError) {
          return Center(child: Text(state.error));
        } else if (state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is HomeLoading) {
          return Column(
            children: [
              Text(
                "TEAMS",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  foreground: Paint()
                    ..strokeWidth = 0.5
                    ..color = Colors.white
                    ..style = PaintingStyle.stroke,
                ),
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          );
        } else if (state is HomeLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Text(
                  "TEAMS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    foreground: Paint()
                      ..strokeWidth = 0.5
                      ..color = Colors.white
                      ..style = PaintingStyle.stroke,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  height: 315,
                  width: 370,
                  child: GridView.builder(
                      physics: const ScrollPhysics(),
                      padding: const EdgeInsets.all(2),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                      ),
                      itemCount: state.teamsList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(
                                  color: Colors.white,
                                )),
                            child: MaterialButton(
                              onPressed: () {},
                              color: Colors.transparent,
                              splashColor: const Color(0xff17408B),
                              child: Text(
                                state.teamsList[index].abbreviation ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 9.1,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
              const Divider(
                height: 1,
                thickness: 1,
                indent: 50,
                endIndent: 50,
                color: Colors.white,
              )
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class AllPlayers extends StatefulWidget {
  const AllPlayers({super.key});

  @override
  State<AllPlayers> createState() => _AllPlayersState();
}

class _AllPlayersState extends State<AllPlayers> {
  @override
  void initState() {
    context.read<PlayerBloc>().add(GetPlayerList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerError) {
          return Center(child: Text(state.error));
        } else if (state is PlayerInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PlayerLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PlayerLoaded) {
          return Padding(
            padding: const EdgeInsets.only(right: 4, left: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ALL",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          foreground: Paint()
                            ..strokeWidth = 0.5
                            ..color = Colors.white
                            ..style = PaintingStyle.stroke,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.settings,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: state.playerList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onDoubleTap: (){
                          teamBloc.addTeamFetchedEvent(player: state.playerList[index]);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("${state.playerList[index].first_name} is added to your team.")));
                        },
                        onLongPress: (){
                          teamBloc.removeTeamFetchedEvent(player: state.playerList[index]);
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text("${state.playerList[index].first_name} is removed from your team.")));
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(
                                right: 8.0, left: 8.0, bottom: 4, top: 4),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  )),
                              child: Card(
                                color: Colors.transparent,
                                elevation: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                          )),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            'lib/images/nba.webp',
                                            fit: BoxFit.fitHeight,
                                            width: 110,
                                            height: 130,
                                          )),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "${state.playerList[index].first_name} ${state.playerList[index].last_name}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "${state.playerList[index].height_feet ?? '0'}' ${state.playerList[index].height_inches ?? '0'}''",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w100,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 80,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "Position: ${state.playerList[index].position ?? ''}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w200,
                                                  ),
                                                ),
                                                Text(
                                                  "${state.playerList[index].weight_pounds ?? '0'} lbs",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w100,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
