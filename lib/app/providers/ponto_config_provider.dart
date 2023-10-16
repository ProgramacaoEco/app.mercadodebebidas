import 'package:loja_mercado_de_bebidas/app/model/PontoConfig.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PontoConfigProvider extends ChangeNotifier {
  late PontoConfig _pontoConfig;
  PontoConfig get pontoConfig => _pontoConfig;

  Future getPontoConfig() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    var response = await Dio()
        .get('${Constants.API_BASIC_ROUTE}/public/api/desconto',
            options: Options(headers: {'token': token}))
        .then((response) => {
              if (response.statusCode == 409)
                {setValuePointConfig(response.data)},
              if (response.statusCode == 200)
                {setValuePointConfig(response.data)},
            });
    return pontoConfig;
  }

  setValuePointConfig(data) {
    _pontoConfig = PontoConfig(
        id: data['id'],
        nome: data['nome_ponto'],
        valorPonto: data['valor_ponto'],
        valorDivisao: data['valor_divider'],
        isActive: data['isActive']);
    notifyListeners();
  }
}
