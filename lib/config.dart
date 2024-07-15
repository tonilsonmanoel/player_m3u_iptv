import 'dart:io';

import 'package:app_m3u/model/model_playlist.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:better_player/better_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  @override
  void initState() {
    super.initState();
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
                    Expanded(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Image.asset(
                            "assets/config_icon.png",
                            height: heightMedia * 0.09,
                            width: widthMedia * 0.08,
                          ),
                          AutoSizeText(
                            "CONFIGURAÇÕES",
                            minFontSize: 18,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lalezar(
                                color: Colors.white,
                                fontSize: 25,
                                height: 1,
                                fontWeight: FontWeight.normal),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                // Row superior View
                SizedBox(
                  height: heightMedia * 0.13,
                ),
                Image.asset(
                  "assets/logotv.png",
                  height: heightMedia * 0.35,
                  width: widthMedia * 0.35,
                ),
                SizedBox(
                  height: heightMedia * 0.05,
                ),
                AutoSizeText(
                  "Player M3U IPTV",
                  minFontSize: 20,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lalezar(
                      color: Colors.white,
                      fontSize: 32,
                      height: 1,
                      fontWeight: FontWeight.normal),
                ),
                AutoSizeText(
                  "Desenvolvidor por Tony Dev - 2024",
                  minFontSize: 18,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 18,
                      height: 1,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          )),
    );
  }
}
