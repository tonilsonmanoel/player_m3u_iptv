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

class GerenciarPlaylist extends StatefulWidget {
  const GerenciarPlaylist({super.key});

  @override
  State<GerenciarPlaylist> createState() => _GerenciarPlaylistState();
}

class _GerenciarPlaylistState extends State<GerenciarPlaylist> {
  List<Map<String, String>> listaPlaylist = [];
  List<String> options = [];
  String? currentOption;
  final focusVoltar = FocusNode();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
    carregarPlaylist();
  }

  void carregarPlaylist() async {
    var resultPlaylist = await ModelPlaylist().getPlaylist();
    var resultCurrentOption = await ModelPlaylist().getPlaylistSelecionada();
    List<String> optionsResult = [];
    if (resultPlaylist.isNotEmpty) {
      optionsResult = List.generate(
        resultPlaylist.length,
        (index) => resultPlaylist[index]["path"]!,
      );
    }

    setState(() {
      listaPlaylist = resultPlaylist;
      options = optionsResult;
      currentOption = resultCurrentOption;
    });

    print('${resultPlaylist.last["nome"]}');
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
                // Row superior View
                Row(
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
                    const Spacer(),
                    Wrap(
                      alignment: WrapAlignment.center,
                      direction: Axis.horizontal,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Image.asset(
                          "assets/playlist_icon.png",
                          height: heightMedia * 0.09,
                          width: widthMedia * 0.08,
                        ),
                        AutoSizeText(
                          "GERENCIAMENTO\nDE PLAYLIST",
                          minFontSize: 15,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lalezar(
                              color: Colors.white,
                              fontSize: 22,
                              height: 1,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles();

                        if (result != null) {
                          File filePlaylist = File(result.files.single.path!);

                          // Verificação ser é arquivo m3u
                          print("Path: ${filePlaylist.path}");
                          if (filePlaylist.path.endsWith(".m3u")) {
                            //verificação playlist já existente e Salva Playlist
                            String nomePlaylist = filePlaylist.path
                                .split('/')
                                .last
                                .replaceAll(".m3u", "");
                            bool nomePlaylistNaoEncontrado = true;

                            listaPlaylist.forEach(
                              (element) {
                                if (nomePlaylist.contains(element["nome"]!)) {
                                  nomePlaylistNaoEncontrado = false;
                                }
                              },
                            );

                            if (nomePlaylistNaoEncontrado) {
                              ModelPlaylist().salvarPlaylist(
                                  nomePlaylist: nomePlaylist,
                                  pathFile: filePlaylist.path);

                              var itemPlaylist = {
                                "nome": nomePlaylist,
                                "path": filePlaylist.path,
                              };

                              setState(() {
                                listaPlaylist.add(itemPlaylist);

                                options.add(filePlaylist.path);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Playlist já adicionado.")));
                            }
                            // Fim verificação playlist já existente
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Selecione uma arquivo .m3u")));
                          }
                          // Fim Verificação ser é arquivo m3u
                        } else {
                          // User canceled the picker
                        }
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 45,
                      ),
                      label: AutoSizeText(
                        "Adicionar\nPlaylist",
                        minFontSize: 13,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                              Colors.blueAccent.shade700)),
                    ),
                  ],
                ),
                // Row superior View
                const SizedBox(
                  height: 10,
                ),
                //
                Expanded(
                  child: ListView.separated(
                    itemCount: listaPlaylist.length,
                    padding:
                        EdgeInsets.symmetric(horizontal: widthMedia * 0.03),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Radio(
                          value: options[index],
                          focusColor: const Color.fromARGB(255, 0, 121, 177),
                          fillColor: const WidgetStatePropertyAll(Colors.white),
                          groupValue: currentOption,
                          onChanged: (value) {
                            ModelPlaylist()
                                .setPlaylistSelecionada(pathPaylist: value!);
                            setState(() {
                              currentOption = value;
                            });
                          },
                        ),
                        title: AutoSizeText(
                          listaPlaylist[index]["nome"]!,
                          maxLines: 1,
                          style: GoogleFonts.roboto(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          focusColor: Colors.white,
                          onPressed: () {
                            ModelPlaylist().removePlaylist(
                                nomePlaylist: listaPlaylist[index]["nome"]!,
                                pathPlaylist: listaPlaylist[index]["path"]!);
                            setState(() {
                              listaPlaylist.removeAt(index);

                              options.removeAt(index);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                  ),
                )

                //
              ],
            ),
          )),
    );
  }
}
