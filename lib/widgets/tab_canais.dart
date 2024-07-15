import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabCanais {
  Widget tabCanal(
    void atualizarPlayerCanal, {
    required String nomeCanal,
    required String idCanal,
    required String logoCanal,
    required String urlCanal,
    required String groupCanal,
  }) {
    return ListTile(
      leading: Image.network(urlCanal),
      title: Text(nomeCanal),
      subtitle: Text(groupCanal),
      trailing: IconButton(
          onPressed: () {
            atualizarPlayerCanal;
          },
          icon: const Icon(Icons.play_arrow)),
    );
  }
}
