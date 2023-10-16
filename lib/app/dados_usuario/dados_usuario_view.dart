import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loja_mercado_de_bebidas/app/endereco_usuario/editar_endereco_usuario_view.dart';
import 'package:loja_mercado_de_bebidas/app/model/user.dart';
import 'package:loja_mercado_de_bebidas/app/model/user_endereco.dart';
import 'package:loja_mercado_de_bebidas/app/providers/user_data_provider.dart';
import 'package:loja_mercado_de_bebidas/app/registro_usuario/registrar_usuario_controller.dart';
import 'package:loja_mercado_de_bebidas/app/usuario/usuario_controller.dart';
import 'package:loja_mercado_de_bebidas/app/widgets/colors.dart';
import 'package:provider/provider.dart';

class DadosUsuarioView extends StatefulWidget {
  @override
  State<DadosUsuarioView> createState() => _DadosUsuarioViewState();
}

class _DadosUsuarioViewState extends State<DadosUsuarioView> {
  @override
  Cores cor = Cores();
  User? _user;
  List<UserEndereco> _userEndereco = [];
  bool isLoading = true;

  final snackBarErr = const SnackBar(
      content: Text(
        'Não foi possivel excluir a conta',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.redAccent);

  final snackBarSuccess = const SnackBar(
      content: Text(
        'Conta excluida com successo',
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.blueAccent);

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text("Tem certeza que deseja excluir seu usuário?",
              style: TextStyle(color: Colors.white)),
          content: Text(
              "Ao excluir seu usuário sua conta será deletada permanentemente e seus dados serão perdidos. Deseja excluir mesmo assim?",
              style: TextStyle(color: Colors.white)),
          actions: [
            Row(children: [
              Container(
                width: 90,
                height: 30,
                color: Colors.grey[800],
                child: FlatButton(
                  child:
                      Text("Cancelar", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15),
                width: 90,
                height: 30,
                color: Colors.redAccent,
                child: FlatButton(
                  child: Text("Exluir", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _registroUsuarioController.deleteUser().then((value) {
                      if (value == false) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(snackBarErr);
                      }
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBarSuccess);
                      Navigator.pushNamed(context, '/home');
                    });
                  },
                ),
              ),
            ]),
          ],
        );
      },
    );
  }

  final RegistroUsuarioController _registroUsuarioController =
      RegistroUsuarioController();

  @override
  void initState() {
    super.initState();
    Provider.of<UserDataList>(context, listen: false).index().then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  setDataUser(BuildContext context) {
    final userProvider = Provider.of<UserDataList>(context);
    setState(() {
      _user = userProvider.user;
      _userEndereco = userProvider.adress;
    });
  }

  @override
  Widget build(BuildContext context) {
    setDataUser(context);

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    final userProvider = Provider.of<UserDataList>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: MediaQuery.of(context).size.height >= 650
            ? MediaQuery.of(context).size.height / 13
            : MediaQuery.of(context).size.height / 11,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back, size: 21),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
          );
        }),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(cor.cCinza1),
                Color(cor.cCinza22),
                Color(cor.cCinza22),
                Color(cor.cCinza3),
              ],
            ),
          ),
        ),
        title: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          height: MediaQuery.of(context).size.height / 11,
          child: Image.asset(
            'assets/logoamandaraupp.jpeg',
          ),
        ),
        elevation: 5,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(cor.cCinza1),
              Color(cor.cCinza22),
              Color(cor.cCinza22),
              Color(cor.cCinza3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                        width: width * 0.7,
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text('Nome: ',
                                      style: TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                  Text('Telefone: ',
                                      style: TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                  Text('CPF: ',
                                      style: TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(_user!.nome,
                                      style: const TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                  Text(_user!.telefone,
                                      style: const TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                  Text(_user!.cpf,
                                      style: const TextStyle(
                                          fontSize: 19, color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: SizedBox(
                        width: width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                child: const Text('Editar dados',
                                    style: TextStyle(color: Colors.blueAccent)),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/editarDadosUsuario');
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: SizedBox(
                        width: width * 0.8,
                        child: const Divider(
                          color: Colors.white,
                          height: 3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Text('Endereço de entrega:',
                        style: TextStyle(fontSize: 19, color: Colors.white)),
                  ),
                  isLoading
                      ? SizedBox(
                          height: height * 0.2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        )
                      : userProvider.adressCount == 1
                          ? SizedBox(
                              width: width * 0.8,
                              height: height * 0.20,
                              child: ListView.builder(
                                  padding: const EdgeInsets.all(8),
                                  itemCount: _userEndereco.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SizedBox(
                                      height: height * 0.17,
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            height: height * 0.12,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.grey[900]),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: width * 0.70,
                                                  height: height * 0.1,
                                                  child: Text(
                                                    'Bairro ${_userEndereco[index].bairro['nome'].toString()}, ${_userEndereco[index].rua} nº ${_userEndereco[index].numero.toString()}, ${_userEndereco[index].complemento}',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: width * 0.7,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  InkWell(
                                                      child: const Text(
                                                          'Editar endereço',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blueAccent)),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (_) =>
                                                                    EditarEnderecoUsuario(
                                                                        idAdress:
                                                                            _userEndereco[index].id)));
                                                      })
                                                ],
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: width * 0.7,
                                              child: const Divider(
                                                color: Colors.white,
                                                height: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                    );
                                  }),
                            )
                          : userProvider.adressCount == 2
                              ? SizedBox(
                                  width: width * 0.8,
                                  height: height * 0.35,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: _userEndereco.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: height * 0.17,
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: height * 0.12,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.grey[900]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.70,
                                                      height: height * 0.1,
                                                      child: Text(
                                                        'Bairro ${_userEndereco[index].bairro['nome'].toString()}, ${_userEndereco[index].rua} nº ${_userEndereco[index].numero.toString()}, ${_userEndereco[index].complemento}',
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: width * 0.7,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                          child: const Text(
                                                              'Editar endereço',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent)),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        EditarEnderecoUsuario(
                                                                            idAdress:
                                                                                _userEndereco[index].id)));
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: width * 0.7,
                                                  child: const Divider(
                                                    color: Colors.white,
                                                    height: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        );
                                      }),
                                )
                              : SizedBox(
                                  width: width * 0.8,
                                  height: height * 0.5,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: _userEndereco.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SizedBox(
                                          height: height * 0.17,
                                          child: Center(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                height: height * 0.12,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.grey[900]),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.70,
                                                      height: height * 0.1,
                                                      child: Text(
                                                        'Bairro ${_userEndereco[index].bairro['nome'].toString()}, ${_userEndereco[index].rua} nº ${_userEndereco[index].numero.toString()}, ${_userEndereco[index].complemento}',
                                                        style: TextStyle(
                                                            fontSize: 19,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: width * 0.7,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      InkWell(
                                                          child: const Text(
                                                              'Editar endereço',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent)),
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        EditarEnderecoUsuario(
                                                                            idAdress:
                                                                                _userEndereco[index].id)));
                                                          })
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: width * 0.7,
                                                  child: const Divider(
                                                    color: Colors.white,
                                                    height: 10,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                        );
                                      }),
                                ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(
                      child: SizedBox(
                        width: width * 0.7,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                child: Row(
                                  children: const [
                                    Text('Adicionar endereço',
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 18)),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(Icons.add_circle_outline,
                                          color: Colors.blueAccent),
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/adicionarEndereco');
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: SizedBox(
                  width: width * 0.7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InkWell(
                          child: Row(
                            children: const [
                              Text('Excluir conta',
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 16)),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                                child: Icon(Icons.delete_forever,
                                    color: Colors.redAccent, size: 21),
                              )
                            ],
                          ),
                          onTap: () {
                            _showDialog();
                          })
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
