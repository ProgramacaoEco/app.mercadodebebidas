import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/app/model/produto.dart';
import 'package:loja_mercado_de_bebidas/app/widgets/cardDestaque.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:http/http.dart' as http;

class ProdutosList with ChangeNotifier {
  final List<Produto> _items = [];

  List<Produto> get items => [..._items];

  final List<CustomCardDestaque> _cards = [];

  List<CustomCardDestaque> get cards => [..._cards];

  int get itemsCount {
    return _items.length;
  }

  Future<void> editaQuantidade(idQtde, qtde) async {}

  Future<void> index(String search) async {
    _items.clear();
    _cards.clear();

    var queryParams = {"search": search};

    var url = Uri.https(Constants.API_ROOT_ROUTE,
        '${Constants.API_FOLDERS}getProdutosDestaque', queryParams);
    var response = await http.get(url);
    var produtos = json.decode(response.body).reversed.toList();

    print(response.body);

    for (var produto in produtos) {
      var data;
      int quantidadesSoma = 0;
      if (produto['imagens'].length == 0) {
        data = null;
      } else {
        data = produto['imagens'][0]['path'];
      }
      for (var quantidade in produto['quantidades']) {
        if (quantidade['quantidade'] != null) {
          int quant = quantidade['quantidade'];
          quantidadesSoma = quantidadesSoma + quant;
        }
      }
      if (quantidadesSoma != 0) {
        _items.add(
          Produto(
              id_produto: produto['id_produto'],
              codigoProduto: produto['codigoProduto'],
              descricao_pagamento: produto['descricao_pagamento'],
              descricaoProduto: produto['descricaoProduto'],
              imagens: data,
              valor: double.parse(produto['valor']),
              quantidades: produto['quantidades']),
        );
      }
    }
    for (var produto in _items) {
      _cards.add(
        CustomCardDestaque(produto),
      );
    }
    notifyListeners();
  }
}
