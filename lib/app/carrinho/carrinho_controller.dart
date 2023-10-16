import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:loja_mercado_de_bebidas/app/model/user.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CarrinhoController extends ChangeNotifier {
  var user;

  var data;

  Future<void> verifyUserLogged(BuildContext context) async {
    user = User(
        nome: "sem usuario", cpf: "000.000.000-00", telefone: "(00)00000-0000");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    await http.post(
      Uri.https(Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}auth/me'),
      headers: {'Authorization': 'Bearer $token'},
    ).then((response) async => {
          print(response.statusCode),
          if (response.statusCode == 401)
            {
              await prefs.setBool('isLogged', false),
              await prefs.setString('nomrUsuario', ''),
              await prefs.setString('cpfUsuario', ''),
              await prefs.setString('cpfUsuario', ''),
              Navigator.pushNamed(context, "/login"),
            },
          if (response.statusCode == 200)
            {
              await prefs.setBool('isLogged', true),
              user = jsonDecode(response.body),
              await prefs.setBool('isLogged', true),
              await prefs.setString('nomrUsuario', user['nome']),
              await prefs.setString('cpfUsuario', user['cpf'].toString()),
              await prefs.setString(
                  'telefoneUsuario', user['telefone'].toString()),
              Navigator.pushNamed(context, "/finalizarCompra")
            }
        });
  }
}
