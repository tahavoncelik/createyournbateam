import 'package:createyournbateam/bloc/home_bloc/home_bloc.dart';
import 'package:createyournbateam/bloc/team_bloc/team_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../service/database/team_database.dart';

final client = Client();
final homeBloc = HomeBloc();
final playerBloc = PlayerBloc();
final teamBloc = TeamBloc(TeamDatabase());

class TeamPage extends StatefulWidget {
  final Function()? onTap;
  const TeamPage({super.key, this.onTap});

  @override
  State<TeamPage> createState() => _TeamPageState();
}

var themeChanger = 0;
var themeCourt = 'c.jpeg';

class _TeamPageState extends State<TeamPage> {
  void themeChangerAdd() {
    themeChanger++;
    if (themeChanger > 4) {
      themeChanger = 0;
      setState(() {
        const TeamPage();
      });
    }
    if (themeChanger == 0) {
      themeCourt = 'bc.png';
      setState(() {
        const TeamPage();
        const SelectedPlayers();
      });
    }
    if (themeChanger == 1) {
      themeCourt = 'c.jpeg';
      setState(() {
        const TeamPage();
        const SelectedPlayers();
      });
    }
    if (themeChanger == 2) {
      themeCourt = 'cb.jpeg';
      setState(() {
        const TeamPage();
        const SelectedPlayers();
      });
    }
    if (themeChanger == 3) {
      themeCourt = 'gsw.png';
      setState(() {
        const TeamPage();
        const SelectedPlayers();
      });
    }
    if (themeChanger == 4) {
      themeCourt = 'lal.png';
      setState(() {
        const TeamPage();
        const SelectedPlayers();
      });
    }
  }

  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('lib/images/$themeCourt'),
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: 100,
                right: 100,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: widget.onTap,
                      icon: const Icon(
                        Icons.home_filled,
                        color: Color(0xff17408B),
                        weight: 50,
                        size: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      onPressed: () async {
                        final image = await screenshotController.capture();
                        if (image == null) return;
                        await saveImage(image);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Screenshot saved succesfuly.")));
                      },
                      icon: const Icon(
                        Icons.ios_share_outlined,
                        color: Colors.white,
                        weight: 50,
                        size: 50,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      onPressed: themeChangerAdd,
                      icon: const Icon(
                        Icons.format_paint_outlined,
                        color: Color(0xffC9082A),
                        weight: 50,
                        size: 50,
                      ),
                    ),
                  ],
                ),
              ),
              const Positioned(
                top: 200,
                left: 75,
                child: LeftForward(),
              ),
              const Positioned(
                top: 200,
                right: 75,
                child: RightForward(),
              ),
              const Positioned(
                top: 320,
                left: 160,
                child: Center(),
              ),
              const Positioned(
                top: 450,
                right: 75,
                child: Guard(),
              ),
              const Positioned(
                top: 450,
                left: 75,
                child: PointGuard(),
              ),
            ],
          ),
          bottomSheet: const SelectedPlayers(),
        ),
      ),
    );
  }
}

Future<String> saveImage(Uint8List bytes) async {
  await [Permission.storage].request();

  final time = DateTime.now()
      .toIso8601String()
      .replaceAll('.', '-')
      .replaceAll(':', '-');
  final name = 'nbateam_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name: name);

  return result['filePath'];
}

class SelectedPlayers extends StatefulWidget {
  const SelectedPlayers({super.key});

  @override
  State<SelectedPlayers> createState() => _SelectedPlayersState();
}

class _SelectedPlayersState extends State<SelectedPlayers> {
  @override
  void initState() {
    super.initState();
    teamBloc.getTeam();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<TeamState>(
        stream: teamBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Error : ${snapshot.error}');
          }
          final state = snapshot.data;
          if (state == null) return const SizedBox();
          final players = state.yourTeamList;
          return Container(
            color: Colors.black,
            width: 400,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: players.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onDoubleTap: (){
                    teamBloc.addTeamFetchedEvent(player: players[index]);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("${players[index].first_name} is added to your team.")));
                  },
                  onLongPress: () {
                    teamBloc.removeTeamFetchedEvent(player: players[index]);
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text("${players[index]
                        .first_name} is removed from your team.")));
                  },
                  child: Padding(
                      padding: const EdgeInsets.only(
                          right: 8.0, left: 8.0, bottom: 4, top: 4),
                      child: Draggable<String>(
                        data:
                            "${players[index].first_name} ${players[index].last_name}",
                        feedback: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 70,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('lib/images/nba.webp'),
                                  fit: BoxFit.fitHeight,
                                  opacity: 0.7,
                                ),
                              ),
                              child: Text(
                                "${players[index].first_name} ${players[index].last_name}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                        childWhenDragging: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          width: 70,
                          height: 100,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 70,
                              height: 100,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'lib/images/nba.webp',
                                  ),
                                  fit: BoxFit.fitHeight,
                                  opacity: 0.6,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30, left: 10),
                                child: Text(
                                  "${players[index].first_name} ${players[index].last_name}",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      )),
                );
              },
            ),
          );
        });
  }
}

class Guard extends StatefulWidget {
  const Guard({super.key});

  @override
  State<Guard> createState() => _GuardState();
}

bool isGuardDropped = false;
String guardName = '';

class _GuardState extends State<Guard> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) {
        return isGuardDropped
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/images/nba.webp',
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Text(
                      guardName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
            : Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              );
      },
      onWillAccept: (data) {
        return !isGuardDropped;
      },
      onAccept: (data) {
        setState(() {
          guardName = data;
          isGuardDropped = !isGuardDropped;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data is on fire.")));
      },
    );
  }
}

class PointGuard extends StatefulWidget {
  const PointGuard({super.key});

  @override
  State<PointGuard> createState() => _PointGuardState();
}

bool isPointGuardDropped = false;
String pointGuardName = '';

class _PointGuardState extends State<PointGuard> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) {
        return isPointGuardDropped
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/images/nba.webp',
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Text(
                      pointGuardName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
            : Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              );
      },
      onWillAccept: (data) {
        return !isPointGuardDropped;
      },
      onAccept: (data) {
        setState(() {
          pointGuardName = data;
          isPointGuardDropped = !isPointGuardDropped;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data is on fire.")));
      },
    );
  }
}

class Center extends StatefulWidget {
  const Center({super.key});

  @override
  State<Center> createState() => _CenterState();
}

bool isCenterDropped = false;
String centerName = '';

class _CenterState extends State<Center> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) {
        return isCenterDropped
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/images/nba.webp',
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: 0.7,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Text(
                      centerName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
            : Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              );
      },
      onWillAccept: (data) {
        return !isCenterDropped;
      },
      onAccept: (data) {
        setState(() {
          centerName = data;
          isCenterDropped = !isCenterDropped;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data is on fire.")));
      },
    );
  }
}

class LeftForward extends StatefulWidget {
  const LeftForward({super.key});

  @override
  State<LeftForward> createState() => _LeftForwardState();
}

bool isLeftForwardDropped = false;
String leftForwardName = '';

class _LeftForwardState extends State<LeftForward> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) {
        return isLeftForwardDropped
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/images/nba.webp',
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Text(
                      leftForwardName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ))
            : Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              );
      },
      onWillAccept: (data) {
        return !isLeftForwardDropped;
      },
      onAccept: (data) {
        setState(() {
          leftForwardName = data;
          isLeftForwardDropped = !isLeftForwardDropped;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data is on fire.")));
      },
    );
  }
}

class RightForward extends StatefulWidget {
  const RightForward({super.key});

  @override
  State<RightForward> createState() => _RightForwardState();
}

bool isRightForwardDropped = false;
String rightForwardName = '';

class _RightForwardState extends State<RightForward> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      builder: (context, List<String?> candidateData, rejectedData) {
        return isRightForwardDropped
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 70,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/images/nba.webp',
                      ),
                      fit: BoxFit.fitHeight,
                      opacity: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, left: 10),
                    child: Text(
                      rightForwardName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
            : Container(
                width: 70,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
              );
      },
      onWillAccept: (data) {
        return !isRightForwardDropped;
      },
      onAccept: (data) {
        setState(() {
          rightForwardName = data;
          isRightForwardDropped = !isRightForwardDropped;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data is on fire.")));
      },
    );
  }
}
