import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_mercado_de_bebidas/app/providers/bairros_list.dart';
import 'package:loja_mercado_de_bebidas/app/providers/user_data_provider.dart';
import 'package:provider/provider.dart';

class EditarDadosUsuario extends StatefulWidget {
  @override
  State<EditarDadosUsuario> createState() => _EditarDadosUsuarioState();
}

class _EditarDadosUsuarioState extends State<EditarDadosUsuario> {
  final _formRegister = GlobalKey<FormState>();

  final TextEditingController _nomeCompletoController = TextEditingController();

  final TextEditingController _cpfController =
      MaskedTextController(mask: "000.000.000-00");

  final MaskedTextController _telefoneController =
      MaskedTextController(mask: "(00)00000-0000");

  final snackBar = const SnackBar(
      content: Text(
        'O número de telefone já está sendo utilizado',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent);

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserDataList>(context);

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
                      Text('Registrar usuário:',
                          style: TextStyle(
                              color: Color(0xff444440),
                              fontSize: 20,
                              fontFamily: 'regular'))
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.05),
                    child: Form(
                      key: _formRegister,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _nomeCompletoController,
                                keyboardType: TextInputType.name,
                                validator: (telefone) {
                                  if (telefone == null || telefone.isEmpty) {
                                    return 'Por favor, digite seu nome completo';
                                  }
                                  return null;
                                },
                                style: TextStyle(
                                    color: Colors.white, fontSize: 21),
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Nome completo',
                                  labelStyle: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  prefixIcon:
                                      Icon(Icons.person, color: Colors.white),
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
                                  hintText: 'João da Silva',
                                  hintStyle: TextStyle(
                                      color: Color(0xffc0c0c0), fontSize: 20),
                                ),
                              )),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextFormField(
                                controller: _cpfController,
                                keyboardType: TextInputType.number,
                                validator: (telefone) {
                                  if (telefone == null || telefone.isEmpty) {
                                    return 'Por favor, digite seu CPF';
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
                                  labelText: 'CPF',
                                  labelStyle: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  prefixIcon: Icon(
                                      Icons.document_scanner_outlined,
                                      color: Colors.white),
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
                                  hintText: '000.000.000-00',
                                  hintStyle: TextStyle(
                                      color: Color(0xffc0c0c0), fontSize: 20),
                                ),
                              )),
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
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      Navigator.pushNamed(
                                          context, '/dadosUsuario');
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(Icons.arrow_back,
                                            color: Colors.white, size: 24),
                                        Text(
                                          'Voltar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);

                                      bool saveDataTrue =
                                          await userProvider.updateDataUser(
                                              _nomeCompletoController.text,
                                              _cpfController.text,
                                              _telefoneController.text);

                                      if (!currentFocus.hasPrimaryFocus) {
                                        currentFocus.unfocus();
                                      }

                                      if (saveDataTrue) {
                                        Navigator.pushNamed(
                                            context, '/dadosUsuario');
                                      } else {
                                        _cpfController.clear();
                                        _nomeCompletoController.clear();
                                        _telefoneController.clear();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Salvar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Icon(Icons.save,
                                            color: Colors.white, size: 24),
                                      ],
                                    ),
                                  ),
                                ],
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
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      )),
                )
              ],
            )),
      ),
    );
  }
}
