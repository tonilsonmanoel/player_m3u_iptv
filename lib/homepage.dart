import 'package:app_m3u/config.dart';
import 'package:app_m3u/gerenciar_playlist.dart';
import 'package:app_m3u/live_tv.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  var focusTVLive = FocusNode();
  var focusConfig = FocusNode();
  var focusGerenciarPlayl = FocusNode();
  var focusFechar = FocusNode();
  var focusGerenciarcolor = false;
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);
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
        child: Center(
          child: SizedBox(
            width: widthMedia * 0.80,
            height: heightMedia * 0.65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Inicio Container TV Ao vivo
                InkWell(
                  focusNode: focusTVLive,
                  autofocus: true,
                  onFocusChange: (value) {
                    setState(() {});
                  },
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LiveTv(),
                        ));
                  },
                  child: Container(
                    width: widthMedia * 0.39,
                    height: heightMedia * 0.65,
                    color: const Color.fromARGB(220, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/logotv.png",
                          height: heightMedia * 0.35,
                          width: widthMedia * 0.32,
                        ),
                        SizedBox(
                          height: heightMedia * 0.02,
                        ),
                        AutoSizeText(
                          "TV AO VIVO",
                          minFontSize: 26,
                          maxLines: 1,
                          style: GoogleFonts.lalezar(
                              color: focusTVLive.hasFocus
                                  ? Colors.blue
                                  : Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ),
                // Fim Container TV Ao vivo
                // Inicio Container Opções
                SizedBox(
                  width: widthMedia * 0.395,
                  height: heightMedia * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Inicio Container Configurações
                      InkWell(
                        focusNode: focusConfig,
                        onFocusChange: (value) {
                          setState(() {});
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConfigPage(),
                              ));
                        },
                        child: Container(
                          width: widthMedia * 0.395,
                          height: heightMedia * 0.19,
                          color: const Color.fromARGB(220, 12, 12, 12),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/config_icon.png",
                                  height: heightMedia * 0.11,
                                  width: widthMedia * 0.06,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AutoSizeText(
                                    "CONFIGURAÇÕES",
                                    minFontSize: 22,
                                    maxLines: 1,
                                    style: GoogleFonts.lalezar(
                                        color: focusConfig.hasFocus
                                            ? Colors.blue
                                            : Colors.white,
                                        fontSize: 35,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Fim Container Configurações
                      // Inicio Container Gerenciar Playlist
                      InkWell(
                        focusNode: focusGerenciarPlayl,
                        onFocusChange: (value) {
                          setState(() {});
                        },
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GerenciarPlaylist(),
                              ));
                        },
                        child: Container(
                          width: widthMedia * 0.395,
                          height: heightMedia * 0.19,
                          color: const Color.fromARGB(220, 12, 12, 12),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/playlist_icon.png",
                                  height: heightMedia * 0.11,
                                  width: widthMedia * 0.06,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AutoSizeText(
                                    "GERENCIAMENTO\nDE PLAYLIST",
                                    minFontSize: 22,
                                    maxLines: 2,
                                    style: GoogleFonts.lalezar(
                                        color: focusGerenciarPlayl.hasFocus
                                            ? Colors.blue
                                            : Colors.white,
                                        fontSize: 35,
                                        height: 1,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Fim Container Gerenciar Playlist
                      // Inicio Container Fechar
                      InkWell(
                        focusNode: focusFechar,
                        onTap: () {
                          SystemNavigator.pop();
                        },
                        child: Container(
                          width: widthMedia * 0.395,
                          height: heightMedia * 0.19,
                          color: const Color.fromARGB(220, 12, 12, 12),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  "assets/sair_icone.png",
                                  height: heightMedia * 0.11,
                                  width: widthMedia * 0.06,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: AutoSizeText(
                                    "FECHAR",
                                    minFontSize: 22,
                                    maxLines: 2,
                                    style: GoogleFonts.lalezar(
                                        color: focusFechar.hasFocus
                                            ? Colors.blue
                                            : Colors.white,
                                        fontSize: 35,
                                        height: 1,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Fim Container Fechar
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
