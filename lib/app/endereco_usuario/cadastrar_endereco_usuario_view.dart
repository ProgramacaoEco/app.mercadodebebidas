import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:loja_mercado_de_bebidas/app/model/bairro.dart';
import 'package:loja_mercado_de_bebidas/app/providers/bairros_list.dart';
import 'package:loja_mercado_de_bebidas/app/registro_usuario/registrar_usuario_controller.dart';
import 'package:provider/provider.dart';

class CadastrarEnderecoUsuarioView extends StatefulWidget {
  @override
  State<CadastrarEnderecoUsuarioView> createState() =>
      _CadastrarEnderecoUsuarioViewState();
}

class _CadastrarEnderecoUsuarioViewState
    extends State<CadastrarEnderecoUsuarioView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<BairrosList>(context, listen: false).index();
  }

  final TextEditingController _bairroController = TextEditingController();
  Bairro? _selectedBairro;
  var _nomeBairro;
  int? idBairro;

  final _formRegisterAdress = GlobalKey<FormState>();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();

  final RegistroUsuarioController _registerController =
      RegistroUsuarioController();

  final snackBar = const SnackBar(
      content: Text(
        'Não foi possivel salvar os dados!',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent);

  @override
  Widget build(BuildContext context) {
    final bairrosProvider = Provider.of<BairrosList>(context);
    List<Bairro> _bairros = bairrosProvider.bairros;

    return MaterialApp(
      home: Scaffold(
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
                        key: _formRegisterAdress,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: DropdownButtonFormField(
                                dropdownColor: Colors.black45,
                                decoration: const InputDecoration(
                                  hintStyle: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                  focusColor: Colors.white,
                                  contentPadding: EdgeInsets.zero,
                                  labelText: 'Selecione seu bairro',
                                  labelStyle: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  prefixIcon: Icon(Icons.location_city_rounded,
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
                                ),
                                isExpanded: true,
                                value: _selectedBairro,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Row(
                                    children: [
                                      Text(_selectedBairro != null
                                          ? _selectedBairro!.nome.toString()
                                          : "Selecione o bairro"),
                                    ],
                                  ),
                                ),
                                items: _bairros.map((bairro) {
                                  return DropdownMenuItem(
                                    value: bairro,
                                    child: Text(
                                      bairro.nome.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 21),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedBairro = newValue as Bairro?;
                                  });
                                },
                                validator: (value) {
                                  if (value == null) return;
                                },
                              ),
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  controller: _ruaController,
                                  keyboardType: TextInputType.text,
                                  validator: (telefone) {
                                    if (telefone == null || telefone.isEmpty) {
                                      return 'Por favor, informe o logradouro';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    labelText: 'Logradouro',
                                    labelStyle: TextStyle(
                                      fontSize: 21,
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(Icons.add_road_rounded,
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
                                    hintText:
                                        'Ex: rua Aurora, Av. Rio Branco...',
                                    hintStyle: TextStyle(
                                        color: Color(0xffc0c0c0), fontSize: 20),
                                  ),
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  controller: _numeroController,
                                  keyboardType: TextInputType.number,
                                  validator: (telefone) {
                                    if (telefone == null || telefone.isEmpty) {
                                      return 'Por favor, informe o numero da residencia';
                                    }
                                    return null;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    labelText: 'Número',
                                    labelStyle: TextStyle(
                                      fontSize: 21,
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(Icons.house_rounded,
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
                                    hintText: 'Informe o número da residencia',
                                    hintStyle: TextStyle(
                                        color: Color(0xffc0c0c0), fontSize: 20),
                                  ),
                                )),
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: TextFormField(
                                  controller: _complementoController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 21),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    labelText: 'Complemento',
                                    labelStyle: TextStyle(
                                      fontSize: 21,
                                      color: Colors.white,
                                    ),
                                    prefixIcon: Icon(Icons.more_horiz_rounded,
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
                                    hintText: 'complemento',
                                    hintStyle: TextStyle(
                                        color: Color(0xffc0c0c0), fontSize: 20),
                                  ),
                                )),
                            Container(
                              margin: EdgeInsets.only(
                                  right:
                                      MediaQuery.of(context).size.width * 0.08),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      FocusScopeNode currentFocus =
                                          FocusScope.of(context);
                                      if (_formRegisterAdress.currentState!
                                          .validate()) {
                                        bool saveDataTrue =
                                            await _registerController
                                                .registerUserWithAdress(
                                          _selectedBairro!.id,
                                          _ruaController.text,
                                          int.parse(_numeroController.text),
                                          _complementoController.text,
                                        );

                                        if (!currentFocus.hasPrimaryFocus) {
                                          currentFocus.unfocus();
                                        }

                                        if (saveDataTrue) {
                                          Navigator.pushNamed(context, '/home');
                                        } else {
                                          setState(() {
                                            _selectedBairro = "" as Bairro?;
                                          });
                                          _ruaController.clear();
                                          _numeroController.clear();
                                          _complementoController.clear();

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Avançar',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        Icon(Icons.next_plan_rounded,
                                            color: Colors.white, size: 24),
                                      ],
                                    ),
                                  ),
                                ],
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
      ),
    );
  }
}
