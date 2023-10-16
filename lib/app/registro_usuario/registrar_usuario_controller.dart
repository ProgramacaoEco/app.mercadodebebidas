import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RegistroUsuarioController extends ChangeNotifier {
  final _message = 'Não foi possivel salvar os dados!';
  Future<bool> saveDataUser(String nome, String cpf, String telefone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('nome_usuario', nome);
    prefs.setString('cpf_usuario', cpf);
    prefs.setString('telefone_usuario', telefone);

    if (prefs.getString('nome_usuario') == null) {
      return false;
    }
    if (prefs.getString('cpf_usuario') == null) {
      return false;
    }
    if (prefs.getString('telefone_usuario') == null) {
      return false;
    }

    return true;
  }

  Future<bool> login(String nome, String cpf, String telefone, int idBairro,
      int numero, String complemento) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = Uri.parse('${Constants.API_BASIC_ROUTE}/public/api/auth/login');

    var response = await http.post(url,
        body: jsonEncode({"telefone": telefone}),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });

    print(response.body);
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['access_token'];
      prefs.setString('tokenUser', token);
      return true;
    } else {
      print(jsonDecode(response.body));
      return false;
    }
  }

  Future<bool> registerUserWithAdress(
      int bairro, String rua, int numero, String complemento) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? nomeUsuario = prefs.getString('nome_usuario');
    String? cpfUsuario = prefs.getString('cpf_usuario');
    String? telefoneUsuario = prefs.getString('telefone_usuario');

    var enderecoEntrega = {
      "id_bairro": bairro,
      "rua": rua,
      "numero": numero,
      "complemento": complemento
    };

    var url =
        Uri.parse('${Constants.API_BASIC_ROUTE}/public/api/auth/register');

    var response = await http.post(url,
        body: jsonEncode({
          "nome": nomeUsuario,
          "cpf": cpfUsuario,
          "telefone": telefoneUsuario,
          "endereco_entrega": enderecoEntrega
        }),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        });
    print(response.body);
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['authorisation']['token'];
      prefs.setString('tokenUser', token);
      print(response.body);
      return true;
    }
    if (response.statusCode == 422) {
      return false;
    }
    if (response.statusCode == 500) {
      return false;
    }
    return false;
  }

  Future<bool> updateDeliveryAdress(String idAdress, String idBairro,
      String rua, String complemento, String numero) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(Constants.API_ROOT_ROUTE,
          '${Constants.API_FOLDERS}auth/updateDeliveryAdress/$idAdress'),
      body: {
        "id_bairro": idBairro,
        "rua": rua,
        "complemento": complemento,
        "numero": numero,
      },
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("tokenUser").toString();

    var response = await http.delete(
      Uri.https(Constants.API_ROOT_ROUTE,
          '${Constants.API_FOLDERS}auth/deleteAppUser'),
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.body);
    if (response.statusCode == 200) {
      prefs.setString('tokenUser', '');
      return true;
    }
    return false;
  }
}
