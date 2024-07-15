import 'dart:io';

import 'package:app_m3u/widgets/tab_canais.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:better_player/better_player.dart';
import 'package:lecle_yoyo_player/lecle_yoyo_player.dart';
import 'package:vimeo_video_player/vimeo_video_player.dart';
import 'package:path_provider/path_provider.dart';

class VideoplayerTwo extends StatefulWidget {
  const VideoplayerTwo({Key? key}) : super(key: key);

  @override
  _VideoplayerTwoState createState() => _VideoplayerTwoState();
}

class _VideoplayerTwoState extends State<VideoplayerTwo> {
  bool fullscreen = false;
  String url = "";
  List<Map<String, String>> canaisList = [];
  late BetterPlayerController betterPlayerController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    betterPlayerController = BetterPlayerController(
      betterPlayerDataSource: BetterPlayerDataSource.network(url),
      BetterPlayerConfiguration(
          autoDispose: true, aspectRatio: 16 / 9, autoPlay: true),
    );
  }

  void atualizarPlayerCanal({required String urlCanal}) {
    betterPlayerController.dispose();
    setState(() {
      betterPlayerController = BetterPlayerController(
        betterPlayerDataSource: BetterPlayerDataSource.network(urlCanal),
        const BetterPlayerConfiguration(
            autoDispose: true, aspectRatio: 16 / 9, autoPlay: true),
      );
      url = urlCanal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            "assets/deleta_icon.png",
            height: 150,
            width: 150,
          ),
          if (url != "") ...[
            AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(
                  controller: betterPlayerController,
                )),
          ] else ...[
            Container(
              height: 90,
              width: double.infinity,
              child: Center(
                child: Text("Nenhum Canal Selecionado"),
              ),
            )
          ],
          ElevatedButton(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  File file = File(result.files.single.path!);
                  final directory = await getApplicationDocumentsDirectory();

                  String fileContent = await file.readAsString();
                  String pattern =
                      r'tvg-id="([^"]+)" tvg-logo="([^"]+)" group-title="([^"]+)",([^,\n]+)\n(https?://[^\s]+)';
                  List<Map<String, String>> canais = [];
                  RegExp regExptvCanais = RegExp(pattern);
                  Iterable<Match> matchesCanais =
                      regExptvCanais.allMatches(fileContent);

                  canais = matchesCanais.map((match) {
                    return {
                      'id': match.group(1) ?? '',
                      'logo': match.group(2) ?? '',
                      'group': match.group(3) ?? '',
                      'name': match.group(4) ?? '',
                      'url': match.group(5) ?? '',
                    };
                  }).toList();
                  setState(() {
                    canaisList = canais;
                  });

                  print("m3u ids: ${canais.last}");
                } else {
                  // User canceled the picker
                }
              },
              child: Text("Selecionar arquivo m3u")),
          if (canaisList.isNotEmpty) ...[
            Expanded(
                child: ListView.builder(
                    itemCount: canaisList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          canaisList[index]["logo"]!,
                          height: 50,
                          width: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(canaisList[index]["name"]!),
                        subtitle: Text(canaisList[index]["group"]!),
                        trailing: IconButton(
                            onPressed: () {
                              atualizarPlayerCanal(
                                  urlCanal: canaisList[index]["url"]!);
                            },
                            icon: const Icon(Icons.play_arrow)),
                      );
                    })),
          ]
        ],
      ),
    );
  }
}
