import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  final snackBar = const SnackBar(
      content: Text(
        'Não foi possível encontrar registro desse telefone. Por favor verifique a credencial e tente novamente!',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent);

  Future<bool> login(String telefone) async {
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
}
