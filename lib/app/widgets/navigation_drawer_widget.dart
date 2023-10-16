import 'package:flutter/material.dart';
import 'package:loja_mercado_de_bebidas/app/carrinho/carrinho_controller.dart';
import 'package:loja_mercado_de_bebidas/app/usuario/usuario_controller.dart';
import 'package:loja_mercado_de_bebidas/app/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  void initState() {
    super.initState();
    setDataUser();
  }

  setDataUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLogged = prefs.getBool('isLogged')!;
      nomeUsuario = prefs.getString('nomeUsuario')!;
      cpfUsuario = prefs.getString('cpfUsuario')!;
      telefoneUsuario = prefs.getString('telefoneUsuario')!;
    });
  }

  UsuarioController usuarioController = UsuarioController();
  var nomeUsuario;
  var telefoneUsuario;
  var cpfUsuario;
  bool isLogged = false;

  Cores cor = Cores();
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
          color: Color(cor.cCinza3),
          child: isLogged == true
              ? ListView(
                  padding: padding,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    buildHeader(
                        context: context,
                        nome: nomeUsuario,
                        telefone: telefoneUsuario,
                        cpf: cpfUsuario,
                        onClicked: () {
                          Navigator.pushNamed(context, '/dadosUsuario');
                        }),
                    Divider(color: Colors.white),
                    const SizedBox(
                      height: 5,
                    ),
                    buildMenuItem(
                        text: 'Editar dados do Usuario',
                        icon: Icons.person_outline,
                        onClicked: () {
                          Navigator.pushNamed(context, '/dadosUsuario');
                        }),
                    const SizedBox(
                      height: 5,
                    ),
                    /*buildMenuItem(
                        text: 'Pesquisa',
                        icon: Icons.search_rounded,
                        onClicked: () {
                          Navigator.pushNamed(context, '/pesquisaProdutos');
                        }),
                    const SizedBox(
                      height: 5,
                    ),*/
                    buildMenuItem(
                        text: 'Sair',
                        icon: Icons.logout_rounded,
                        onClicked: () {
                          usuarioController.logout();
                          Navigator.pushNamed(context, '/home');
                        })
                  ],
                )
              : ListView(
                  padding: padding,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    buildHeader(
                        context: context,
                        nome: nomeUsuario,
                        telefone: telefoneUsuario,
                        cpf: cpfUsuario,
                        onClicked: () {
                          Navigator.pushNamed(context, '/dadosUsuario');
                        }),
                    Divider(color: Colors.white),
                    const SizedBox(
                      height: 5,
                    ),
                    /*buildMenuItem(
                        text: 'Pesquisa',
                        icon: Icons.search_rounded,
                        onClicked: () {
                          Navigator.pushNamed(context, '/pesquisaProdutos');
                        }),
                    const SizedBox(
                      height: 5,
                    ),*/
                    buildMenuItem(
                        text: 'Login',
                        icon: Icons.login_rounded,
                        onClicked: () {
                          Navigator.pushNamed(context, '/login');
                        })
                  ],
                )),
    );
  }
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  required onClicked,
}) {
  const color = Colors.white;
  const hoverColor = Colors.white54;
  return ListTile(
    leading: Icon(
      icon,
      color: color,
      size: 21,
    ),
    hoverColor: hoverColor,
    title: Text(text, style: TextStyle(color: color, fontSize: 16)),
    onTap: onClicked,
  );
}

Widget buildHeader(
        {required String nome,
        required String telefone,
        required String cpf,
        required onClicked,
        required BuildContext context}) =>
    InkWell(
        onTap: onClicked,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text('Nome usuario: ',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(nome,
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
              Row(
                children: [
                  Text('CPF usuario: ',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(cpf, style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
              Row(
                children: [
                  Text('Telefone usuario: ',
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(telefone,
                      style: TextStyle(color: Colors.white, fontSize: 14))
                ],
              ),
            ],
          ),
        ));
