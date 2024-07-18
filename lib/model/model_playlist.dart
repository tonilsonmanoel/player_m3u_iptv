import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ModelPlaylist {
  void salvarPlaylist(
      {required String pathFile, required String nomePlaylist}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listNomePlaylist = prefs.getStringList('listNomePLaylist');
    List<String>? listPathFile = prefs.getStringList('listPathFile');
    if ((listPathFile != null && listNomePlaylist != null) &&
        (listPathFile.isNotEmpty && listNomePlaylist.isNotEmpty)) {
      listNomePlaylist.add(nomePlaylist);
      listPathFile.add(pathFile);
      await prefs.setStringList('listNomePLaylist', listNomePlaylist);
      await prefs.setStringList('listPathFile', listPathFile);
    } else {
      await prefs.setStringList('listNomePLaylist', [nomePlaylist]);
      await prefs.setStringList('listPathFile', [pathFile]);
    }
  }

  Future<List<Map<String, String>>> getPlaylist() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listNomePlaylist = prefs.getStringList('listNomePLaylist');
    List<String>? listPathFile = prefs.getStringList('listPathFile');
    List<Map<String, String>> listaPlaylist = [];

    //
    if (listNomePlaylist != null && listPathFile != null) {
      for (var i = 0; i < listNomePlaylist.length; i++) {
        var itemPlaylist = {
          "nome": listNomePlaylist[i],
          "path": listPathFile[i],
        };
        listaPlaylist.add(itemPlaylist);
      }
    }
    //
    return listaPlaylist;
  }

  void removePlaylist(
      {required String nomePlaylist, required String pathPlaylist}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? listNomePlaylist = prefs.getStringList('listNomePLaylist');
    List<String>? listPathFile = prefs.getStringList('listPathFile');
    if (listNomePlaylist != null && listPathFile != null) {
      listNomePlaylist.remove(nomePlaylist);
      listPathFile.remove(pathPlaylist);
      await prefs.setStringList('listNomePLaylist', listNomePlaylist);
      await prefs.setStringList('listPathFile', listPathFile);
    }
  }

  void setPlaylistSelecionada({required String pathPaylist}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('paylistSelecionada', pathPaylist);
  }

  Future<String?> getPlaylistSelecionada() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? listPathFile = prefs.getString('paylistSelecionada');
    if (listPathFile != null) {
      return listPathFile;
    }
    return null;
  }

  Future<List<Map<String, String>>> carregarCanais() async {
    String? pathPlaylist = await ModelPlaylist().getPlaylistSelecionada();
    List<Map<String, String>> canais = [];
    if (pathPlaylist != null) {
      File pathFile = File(pathPlaylist);
      String fileContent = await pathFile.readAsString();

      String pattern =
          r'(?:tvg-id="([^"]*)")?(?: tvg-logo="([^"]*)")?(?: group-title="([^"]*)")?,([^,\n]+)\n(https?://[^\s]+)';

      RegExp regExptvCanais = RegExp(pattern);
      Iterable<Match> matchesCanais = regExptvCanais.allMatches(fileContent);

      canais = matchesCanais.map((match) {
        return {
          'id': match.group(1) ?? '',
          'logo': match.group(2) ??
              'http://plone.ufpb.br/labeet/contents/paginas/acervo-brazinst/copy_of_cordofones/udecra/sem-imagem.jpg/@@images/image.jpeg',
          'group': match.group(3) ?? "Desconhecido",
          'name': match.group(4) ?? '',
          'url': match.group(5) ?? '',
        };
      }).toList();

      return canais;
    }
    return canais;
  }

  List<Map<String, dynamic>> groupCanaisQuantidade(
      {List<Map<String, String>>? listaCanais}) {
    List<String> listGroupName = [];
    List<Map<String, dynamic>> listGroup = [];

    if (listaCanais != null) {
      // remover duplicado do List/Map
      for (var i = 0; i < listaCanais.length; i++) {
        if (!listGroupName.contains(listaCanais[i]["group"])) {
          listGroupName.add(listaCanais[i]["group"]!);
        }
      }
      //Fim remover duplicado do List/Map

      // Grupo de canais

      for (var groupElement in listGroupName) {
        int quantidadeCanaisGrupo = 0;

        for (var element in listaCanais) {
          if (groupElement == element['group']) {
            quantidadeCanaisGrupo += 1;
          }
        }
        listGroup.add({
          'nomeGroup': groupElement,
          'quantidadeCanais': quantidadeCanaisGrupo,
        });
      }

      //Fim Grupo de canais
    }
    return listGroup;
  }
}
