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
}
