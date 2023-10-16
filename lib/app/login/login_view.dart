// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_mercado_de_bebidas/app/login/login_controller.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import '../widgets/colors.dart';
import '../../database/database.dart';

Cores cor = Cores();

class _LoginView extends State<LoginView> {
  LoginController loginController = LoginController();

  DatabaseHelper dbHelper = DatabaseHelper.instance;
  AsyncMemoizer memoizerValores = AsyncMemoizer();

  final _formLogin = GlobalKey<FormState>();
  final MaskedTextController _telefoneController =
      MaskedTextController(mask: "(00)00000-0000");

  final snackBar = const SnackBar(
      content: Text(
        'Não foi possível encontrar registro desse telefone. Por favor verifique a credencial e tente novamente!',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: MediaQuery.of(context).size.height * 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFCCCCC4), Colors.black],
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width < 600
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(top: 35),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo_login.png',
                      ),
                      Text('Login com telefone:',
                          style: TextStyle(
                              color: Color(0xff444440),
                              fontSize: 20,
                              fontFamily: 'regular'))
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.15),
                    child: Form(
                      key: _formLogin,
                      child: Column(
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _telefoneController,
                                keyboardType: TextInputType.number,
                                validator: (telefone) {
                                  if (telefone == null || telefone.isEmpty) {
                                    return 'Por favor, digite o número do seu telefone';
                                  } else if (!RegExp(
                                          r'^\([1-9]{2}\)(?:[2-8]|9[1-9])[0-9]{3}\-[0-9]{4}$')
                                      .hasMatch(_telefoneController.text)) {
                                    return 'Por Favor, digite um telefone válido';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Número de telefone',
                                  labelStyle: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  prefixIcon:
                                      Icon(Icons.phone, color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  hintText: '(99)99999-9999',
                                  hintStyle: TextStyle(
                                      color: Color(0xffc0c0c0), fontSize: 20),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.height * 0.14,
                            child: ElevatedButton(
                              onPressed: () async {
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (_formLogin.currentState!.validate()) {
                                  bool loginTrue = await loginController
                                      .login(_telefoneController.text);

                                  if (!currentFocus.hasPrimaryFocus) {
                                    currentFocus.unfocus();
                                  }

                                  if (loginTrue) {
                                    Navigator.pushNamed(context, '/home');
                                  } else {
                                    _telefoneController.clear();
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                }
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(fontSize: 21),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Colors
                                    .transparent, //cor de fundo transparente
                                side: BorderSide(
                                    color: Colors.white,
                                    width:
                                        1.5), //borda branca com espessura de 2
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), //bordas arredondadas
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.20),
                  child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/registrarUsuario');
                      },
                      child: Text(
                        'Registrar-se',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                )
              ],
            )),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginView();
  }
}
