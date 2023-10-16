import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/app/model/user.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UsuarioController extends ChangeNotifier {
  var user;

  Future<void> isLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(
          Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}auth/verifyLogin'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 401) {
      await prefs.setBool('isLogged', false);
    }
    if (response.statusCode == 200) {
      await prefs.setBool('isLogged', true);
    }
  }

  Future<void> verifyUserLoggedAndSetDataUser() async {
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
              await prefs.setString('nomeUsuario', ''),
              await prefs.setString('cpfUsuario', ''),
              await prefs.setString('telefoneUsuario', '')
            },
          if (response.statusCode == 200)
            {
              user = jsonDecode(response.body),
              await prefs.setBool('isLogged', true),
              await prefs.setString('nomeUsuario', user['nome']),
              await prefs.setString('cpfUsuario', user['cpf'].toString()),
              await prefs.setString(
                  'telefoneUsuario', user['telefone'].toString()),
            }
        });
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(
          Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      prefs.setString('tokenUser', '');
    }
    if (response.statusCode == 401) {
      prefs.setString('tokenUser', '');
    }
  }
}
