import 'dart:io';

import 'package:app_m3u/model/model_playlist.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<Map<String, String>> canaisListViewGroup = [];
  List<Map<String, dynamic>> listGroup = [];
  final focusVoltar = FocusNode();
  List<FocusNode> listfocusGroup = [];
  List<FocusNode> listfocusCanais = [];

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
    List<Map<String, String>> canais = [];
    canais = await ModelPlaylist().carregarCanais();
    var listGroupModel =
        ModelPlaylist().groupCanaisQuantidade(listaCanais: canais);

    setState(() {
      canaisList = canais;
      listGroup = listGroupModel;
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
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
                      focusNode: focusVoltar,
                      onFocusChange: (value) => setState(() {}),
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Ink(
                        child: focusVoltar.hasFocus
                            ? Image.asset(
                                "assets/volta_icon_hover_2.png",
                                height: heightMedia * 0.08,
                                width: widthMedia * 0.05,
                              )
                            : Image.asset(
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
                    // Inicio ListView
                    Container(
                        height: heightMedia * 0.80,
                        width: widthMedia * 0.20,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            if (listGroup.isNotEmpty) ...[
                              Expanded(
                                child: ListView.separated(
                                  itemCount: listGroup.length,
                                  padding: const EdgeInsets.all(2),
                                  itemBuilder: (context, index) {
                                    listfocusGroup.add(FocusNode());
                                    return InkWell(
                                      focusNode: listfocusGroup[index],
                                      onFocusChange: (value) => setState(() {}),
                                      onTap: () {
                                        List<Map<String, String>> lista = [];
                                        for (var i = 0;
                                            i < canaisList.length;
                                            i++) {
                                          if (listGroup[index]["nomeGroup"] ==
                                              canaisList[i]["group"]) {
                                            lista.add(canaisList[i]);
                                          }
                                        }
                                        setState(() {
                                          canaisListViewGroup = lista;
                                        });
                                      },
                                      child: Container(
                                        color: const Color.fromARGB(
                                            220, 12, 12, 12),
                                        child: ListTile(
                                          title: AutoSizeText(
                                            listGroup[index]["nomeGroup"]!,
                                            maxLines: 1,
                                            style: GoogleFonts.roboto(
                                                color: listfocusGroup[index]
                                                        .hasFocus
                                                    ? Colors.blueAccent
                                                    : Colors.white),
                                          ),
                                          trailing: AutoSizeText(
                                              "${listGroup[index]["quantidadeCanais"]!}",
                                              maxLines: 1,
                                              minFontSize: 10,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 15,
                                                  color: listfocusGroup[index]
                                                          .hasFocus
                                                      ? Colors.blueAccent
                                                      : const Color.fromARGB(
                                                          255, 218, 218, 218))),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        )),
                    //Fim listview
                    // Inicio ListView2
                    Container(
                        height: heightMedia * 0.80,
                        width: widthMedia * 0.34,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                                style: BorderStyle.solid)),
                        child: Column(
                          children: [
                            if (canaisListViewGroup.isNotEmpty) ...[
                              Expanded(
                                child: ListView.separated(
                                  itemCount: canaisListViewGroup.length,
                                  padding: const EdgeInsets.all(3),
                                  itemBuilder: (context, index) {
                                    listfocusCanais.add(FocusNode());
                                    return InkWell(
                                      focusNode: listfocusCanais[index],
                                      onFocusChange: (value) => setState(() {}),
                                      onTap: () {
                                        atualizarPlayerCanal(
                                            urlCanal: canaisListViewGroup[index]
                                                ["url"]!,
                                            nomeCanalText:
                                                canaisListViewGroup[index]
                                                    ["name"]!);
                                      },
                                      child: Container(
                                        color: const Color.fromARGB(
                                            220, 12, 12, 12),
                                        child: ListTile(
                                          leading: Image.network(
                                            canaisListViewGroup[index]["logo"]!,
                                            height: 50,
                                            width: 50,
                                            fit: BoxFit.contain,
                                          ),
                                          title: Text(
                                            canaisListViewGroup[index]["name"]!,
                                            style: GoogleFonts.roboto(
                                                color: listfocusCanais[index]
                                                        .hasFocus
                                                    ? Colors.blueAccent
                                                    : Colors.white),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                    height: 5,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        )),
                    //Fim listview 2
                    SizedBox(
                      height: heightMedia * 0.80,
                      width: widthMedia * 0.42,
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
