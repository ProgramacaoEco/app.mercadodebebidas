import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/app/model/user.dart';
import 'package:loja_mercado_de_bebidas/app/model/user_endereco.dart';
import 'package:loja_mercado_de_bebidas/flutter_flow/flutter_flow_util.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserDataList with ChangeNotifier {
  User user = User(nome: '', telefone: '', cpf: '');

  final List<UserEndereco> _adress = [];
  List<UserEndereco> get adress => [..._adress];

  int get adressCount {
    return adress.length;
  }

  Future<void> index() async {
    _adress.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}auth/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/josn',
        'Content-Type': 'application/json'
      },
    );

    print(response.statusCode);
    if (response.statusCode == 401) {
      await prefs.setBool('isLogged', false);
      await prefs.setString('nomeUsuario', '');
      await prefs.setString('cpfUsuario', '');
      await prefs.setString('telefoneUsuario', '');
      _adress.clear();
      notifyListeners();
    }
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var responseAdress = data['endereco_entrega'];

      user = User(
          nome: data['nome'], cpf: data['cpf'], telefone: data['telefone']);

      for (var ad in responseAdress) {
        _adress.add(UserEndereco(
            id: ad['id'],
            rua: ad['rua'],
            numero: ad['numero'],
            complemento: ad['complemento'],
            bairro: ad['bairro']));
      }

      await prefs.setString('nomeUsuario', data['nome']);
      await prefs.setString('cpfUsuario', data['cpf']);

      notifyListeners();
    }
  }

  Future<bool> updateDeliveryAdress(int idAdress, int idBairro, String rua,
      String complemento, int numero) async {
    _adress.clear();
    adress.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(Constants.API_ROOT_ROUTE,
          '${Constants.API_FOLDERS}auth/updateDeliveryAdress/$idAdress'),
      body: jsonEncode({
        "id_bairro": idBairro,
        "rua": rua,
        "complemento": complemento,
        "numero": numero,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/josn',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      adress.clear();
      _adress.clear();
      index();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> createNewDeliveryAdress(
      int idBairro, String rua, String complemento, int numero) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(Constants.API_ROOT_ROUTE,
          '${Constants.API_FOLDERS}auth/saveDeliveryAdress'),
      body: jsonEncode({
        "id_bairro": idBairro,
        "rua": rua,
        "complemento": complemento,
        "numero": numero,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/josn',
        'Content-Type': 'application/json'
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _adress.add(UserEndereco(
          id: data['id'],
          rua: data['rua'],
          numero: data['numero'],
          complemento: data['complemento'],
          bairro: data['bairro']));
      notifyListeners();
      return true;
    }
    if (response.statusCode == 405) {
      print(response.body);
      return false;
    }
    if (response.statusCode == 302) {
      print('deu guru');
      return false;
    } else {
      return false;
    }
  }

  Future<bool> updateDataUser(String nome, String cpf, String telefone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.post(
      Uri.https(
          Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}auth/updateUser'),
      body: jsonEncode({
        "nome": nome,
        "cpf": cpf,
        "telefone": telefone,
      }),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/josn',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      user = User(
          nome: data['nome'], cpf: data['cpf'], telefone: data['telefone']);
      notifyListeners();
      return true;
    }
    if (response.statusCode == 405) {
      return false;
    }
    return false;
  }

  Future<List> getAdressByUserLogged() async {
    _adress.clear();
    adress.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    var response = await http.get(
      Uri.https(Constants.API_ROOT_ROUTE,
          '${Constants.API_FOLDERS}auth/getAdressByUserLogged'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/josn',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var endereco in data) {
        _adress.add(UserEndereco(
            id: endereco['id'],
            rua: endereco['rua'],
            numero: endereco['numero'],
            complemento: endereco["complemento"],
            bairro: endereco['bairro']));
      }
      notifyListeners();
      return adress;
    }
    if (response.statusCode == 405) {}
    return adress;
  }
}
