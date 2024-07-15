import 'dart:io';

import 'package:app_m3u/model/model_playlist.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class LiveTv extends StatefulWidget {
  const LiveTv({super.key});

  @override
  State<LiveTv> createState() => _LiveTvState();
}

class _LiveTvState extends State<LiveTv> {
  late BetterPlayerController betterPlayerController;
  bool fullscreen = false;
  String url = "";
  String nomeCanal = "";
  List<Map<String, String>> canaisList = [];

  void atualizarPlayerCanal({
    required String urlCanal,
    required String nomeCanalText,
  }) {
    betterPlayerController.dispose();
    setState(() {
      betterPlayerController = BetterPlayerController(
        betterPlayerDataSource: BetterPlayerDataSource.network(urlCanal),
        const BetterPlayerConfiguration(
            autoDispose: true, aspectRatio: 16 / 9, autoPlay: true),
      );
      url = urlCanal;
      nomeCanal = nomeCanalText;
    });
  }

  void carregarCanais() async {
    String? pathPlaylist = await ModelPlaylist().getPlaylistSelecionada();
    if (pathPlaylist != null) {
      File pathFile = File(pathPlaylist);
      String fileContent = await pathFile.readAsString();

      String pattern =
          r'(?:tvg-id="([^"]*)")?(?: tvg-logo="([^"]*)")?(?: group-title="([^"]*)")?,([^,\n]+)\n(https?://[^\s]+)';
      List<Map<String, String>> canais = [];
      RegExp regExptvCanais = RegExp(pattern);
      Iterable<Match> matchesCanais = regExptvCanais.allMatches(fileContent);

      canais = matchesCanais.map((match) {
        return {
          'id': match.group(1) ?? '',
          'logo': match.group(2) ??
              'http://plone.ufpb.br/labeet/contents/paginas/acervo-brazinst/copy_of_cordofones/udecra/sem-imagem.jpg/@@images/image.jpeg',
          'group': match.group(3) ?? 'Desconhecido',
          'name': match.group(4) ?? '',
          'url': match.group(5) ?? '',
        };
      }).toList();

      // Grupo de canais
      List<Map<String, int>> listGroup = [];

      // Grupo de canais
      setState(() {
        canaisList = canais;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    carregarCanais();

    betterPlayerController = BetterPlayerController(
      betterPlayerDataSource: BetterPlayerDataSource.network(url),
      const BetterPlayerConfiguration(
          autoDispose: true, aspectRatio: 16 / 9, autoPlay: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    double widthMedia = MediaQuery.of(context).size.width;
    double heightMedia = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/fundo1.jpg"), fit: BoxFit.cover)),
          child: Padding(
            padding: EdgeInsets.only(
              left: widthMedia * 0.02,
              right: widthMedia * 0.02,
              top: heightMedia * 0.05,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink(
                        child: Image.asset(
                          "assets/volta_icon.png",
                          height: heightMedia * 0.08,
                          width: widthMedia * 0.05,
                        ),
                      ),
                    ),
                    Image.asset(
                      "assets/logotv.png",
                      height: heightMedia * 0.09,
                      width: widthMedia * 0.08,
                    ),
                    AutoSizeText(
                      "TV AO VIVO",
                      minFontSize: 20,
                      maxLines: 1,
                      style: GoogleFonts.lalezar(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: heightMedia * 0.80,
                        width: widthMedia * 0.47,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            if (canaisList.isNotEmpty) ...[
                              Expanded(
                                child: ListView.separated(
                                  itemCount: canaisList.length,
                                  padding: const EdgeInsets.all(3),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color:
                                          const Color.fromARGB(220, 12, 12, 12),
                                      child: ListTile(
                                        leading: Image.network(
                                          canaisList[index]["logo"]!,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.contain,
                                        ),
                                        title: Text(
                                          canaisList[index]["name"]!,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                            canaisList[index]["group"]!,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 218, 218, 218))),
                                        trailing: IconButton(
                                            onPressed: () {
                                              atualizarPlayerCanal(
                                                  urlCanal: canaisList[index]
                                                      ["url"]!,
                                                  nomeCanalText:
                                                      canaisList[index]
                                                          ["name"]!);
                                            },
                                            icon: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            )),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 5,
                                  ),
                                ),
                              ),
                            ]
                          ],
                        )),
                    SizedBox(
                      height: heightMedia * 0.80,
                      width: widthMedia * 0.47,
                      child: Column(
                        children: [
                          if (url != "") ...[
                            AspectRatio(
                                aspectRatio: 16 / 9,
                                child: BetterPlayer(
                                  controller: betterPlayerController,
                                )),
                          ] else ...[
                            const AspectRatio(
                                aspectRatio: 16 / 9,
                                child: ColoredBox(color: Colors.black)),
                          ],
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AutoSizeText(
                                  nomeCanal,
                                  minFontSize: 16,
                                  maxLines: 3,
                                  style: GoogleFonts.lalezar(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  betterPlayerController.enterFullScreen();
                                },
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.blueAccent.shade700)),
                                label: AutoSizeText(
                                  "Tela Cheia",
                                  minFontSize: 10,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 15,
                                      height: 1,
                                      fontWeight: FontWeight.bold),
                                ),
                                icon: const Icon(
                                  Icons.fullscreen,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
