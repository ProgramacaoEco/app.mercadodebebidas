import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loja_mercado_de_bebidas/app/model/bairro.dart';
import 'package:loja_mercado_de_bebidas/app/model/itens_pedido.dart';
import 'package:loja_mercado_de_bebidas/app/model/user_endereco.dart';
import 'package:loja_mercado_de_bebidas/app/providers/bairros_list.dart';
import 'package:loja_mercado_de_bebidas/app/providers/itens_pedido_list.dart';
import 'package:loja_mercado_de_bebidas/app/providers/ponto_config_provider.dart';
import 'package:loja_mercado_de_bebidas/app/providers/user_data_provider.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';
import 'package:provider/provider.dart';

import '../../database/database.dart';
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/colors.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FinalizarCompra extends StatefulWidget {
  const FinalizarCompra({Key? key}) : super(key: key);
  @override
  FinalizarCompraState createState() => FinalizarCompraState();
}

Cores cor = Cores();
DatabaseHelper dbHelper = DatabaseHelper.instance;

class FinalizarCompraState extends State<FinalizarCompra> {
  //Gerenciamento de estado
  @override
  void initState() {
    super.initState();
    obterItensPedido();
    Provider.of<UserDataList>(context, listen: false)
        .getAdressByUserLogged()
        .then((value) => {
              setState(
                () => _finalValue =
                    double.parse(valorTotalCarrinho.replaceAll(",", ".")) +
                        num.parse(value[0].bairro['valor_frete'].toString()),
              ),
              setState(
                () => _valorFrete =
                    num.parse(value[0].bairro['valor_frete'].toString()),
              ),
              Provider.of<PontoConfigProvider>(context, listen: false)
                  .getPontoConfig()
                  .then((value) => {
                        setState(() => _pontosConfig = value),
                        print(value),
                        dividerTotalValueGetPoints(
                            _finalValue, _pontosConfig.valorDivisao),
                        calculateValuePoints(
                            _qtdPoints, double.parse(_pontosConfig.valorPonto)),
                        calculateFinalValueWithDiscount(
                            _finalValue, _valueDiscount)
                      }),
            });
  }

  @override
  void dispose() {
    super.dispose();
    //ChecarInternet().listener.cancel();
  }

  var _pontosConfig;
  bool isLoading = true;
  final bool _autovalidate = false;
//variaveis dos valores
  late bool selectbool = false;
  var forma;
  var itensPedido = [];
  late bool carregou;
  var valorTotalCarrinho;
  var pedido = [];
  var busca = 'buscar na loja';
  String pendente = 'pendente';
  var value;

  final List<Map> _payment = [
    {"pay": "Dinheiro"},
    {"pay": "Cartão"},
    {"pay": "Pix"}
  ];
  var _selectedPayment;

  var cidades = [];
  var estados = [];
  var estadoSelecionado;

  //variaveis da tela (CPF/CNPJ)
  var campoNum;
  var campoText;
  var campoNome;

  final _nomeBairro = "";
  num _valorFrete = 00.00;

  var _finalValue;
  var _obs;

  DatabaseHelper dbHelper = DatabaseHelper.instance;

  late http.Response responseparcela;
  late http.Response responsepedido;

  var urlCadastroPedido = Uri.parse(
      '${Constants.API_BASIC_ROUTE}${Constants.API_FOLDERS}auth/cadastrarPedido');

  final _formKey = GlobalKey<FormState>();

  var _idPedido;
  var _messageStoreClosed;
  int _qtdPoints = 0;
  num _finalResultWithDiscount = 00.00;
  num _valueDiscount = 00.00;

  Future<void> getMessageClosedStore() async {
    var url = Uri.https(
        Constants.API_ROOT_ROUTE, '${Constants.API_FOLDERS}getStoreStatus');

    await http.get(url).then((response) {
      var storeStatus = json.decode(response.body);
      setState(() {});
      _messageStoreClosed = storeStatus['message'];
    });
  }

  dividerTotalValueGetPoints(num finalValue, int dividerValue) {
    num qtdPoints = finalValue / dividerValue;
    setState(() {
      _qtdPoints = qtdPoints.toInt();
      isLoading = false;
    });
  }

  calculateFinalValueWithDiscount(num finalFalue, num valueDiscount) {
    num finalResult = finalFalue - valueDiscount;
    setState(() {
      _finalResultWithDiscount = finalResult;
    });
  }

  calculateValuePoints(int qtdPoints, num valuePoint) {
    num valueDiscount = valuePoint * qtdPoints;
    setState(() {
      _valueDiscount = valueDiscount;
    });
  }

  void showMessageClosedStore(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_messageStoreClosed),
        actions: <Widget>[
          FlatButton(onPressed: () => Navigator.pop(ctx), child: Text("voltar"))
        ],
      ),
    );
    Navigator.pop(context, '/home');
  }

  obterItensPedido() async {
    itensPedido.clear();
    // final provider = Provider.of<ListaItensPedido>(context, listen: false);
    var itensPedidoList =
        await Provider.of<ListaItensPedido>(context, listen: false).indexErr();

    for (var item in itensPedidoList) {
      itensPedido.add(
        {
          "id_produto": item.idProduto.toString(),
          "valor_unitario": item.valor.toString(),
          "codigoProduto": item.codigoProduto.toString(),
          "descricaoProduto": item.descricaoProduto.toString(),
          "tamanho": item.tamanho.toString(),
          "quantidade": item.quantidade,
        },
      );
    }
    valorTotalCarrinho = await dbHelper.valorTotalCarrinho();
    valorTotalCarrinho = valorTotalCarrinho[0]['sum(valor)']
        .toStringAsFixed(2)
        .replaceAll(".", ",");
  }

  somaFreteValorFinal(double valorFrete) async {
    setState(() {
      _finalValue =
          double.parse(valorTotalCarrinho.replaceAll(",", ".")) + valorFrete;
    });
  }

  cadastroPedido(value, String payment, obs, int idAdress, itensPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('tokenUser').toString();

    responsepedido = await http.post(urlCadastroPedido,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "valor": value,
          "forma_pagamento": payment,
          "observacao": obs,
          "id_endereco_entrega": idAdress,
          "itens_pedido": itensPedido
        }));
    print(responsepedido.body);
    print(responsepedido.statusCode);
    if (responsepedido.statusCode == 200 || responsepedido.statusCode == 201) {
      var data = jsonDecode(responsepedido.body);
      setState(() {
        _idPedido = data['id_pedido'];
      });
      guardarIdPedido(_idPedido);
      dbHelper.limparCarrinho();
      Navigator.pushNamed(context, '/resumoPedido');
    }
    if (responsepedido.statusCode == 499) {
      showMessageClosedStore(context);
    }
    if (responsepedido.statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('por favor, informe todos os campos obrigatórios')));
    }
  }

  guardarIdPedido(idPedido) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('id_pedido', idPedido);
  }

  guardarDadosEntrega() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('valorTotal', _finalValue.toString());
    prefs.setString('valorFrete', _valorFrete.toString());
    prefs.setString('formaPagamento', _selectedPayment.toString());
  }

  final List<UserEndereco> _userEndereco = [];
  var _adressSelected;

  changeAdress(adressSelected) {
    setState(() {
      _adressSelected = adressSelected;
    });
  }

  int indexAdress = 0;
  //Widget selectedI

  @override
  Widget build(BuildContext context) {
    final dataUserProvider = Provider.of<UserDataList>(context);
    final userAdress = dataUserProvider.adress;

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Pedido com entrega",
              style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 22),
            ),
          ],
        ),
        backgroundColor: Color(cor.tema),
        toolbarHeight: MediaQuery.of(context).size.height >= 650
            ? MediaQuery.of(context).size.height / 13
            : MediaQuery.of(context).size.height / 11,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          child: Container(
                            child: Text(
                              "Selecione o endereço de entrega:",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6c5c54),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: SizedBox(
                      width: width * 0.8,
                      child: isLoading
                          ? SizedBox(
                              height: height * 0.3,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: LoadingAnimationWidget.hexagonDots(
                                      color: Colors.black,
                                      size: 50,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: userAdress.length,
                              itemBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  height: height * 0.12,
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            setState(() {
                                              indexAdress = index;
                                              somaFreteValorFinal(double.parse(
                                                  userAdress[index]
                                                      .bairro['valor_frete']
                                                      .toString()));
                                              _valorFrete = num.parse(
                                                  userAdress[index]
                                                      .bairro['valor_frete']
                                                      .toString());
                                            });
                                            changeAdress(userAdress[index]);
                                          },
                                          child: indexAdress == index
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: Colors
                                                              .greenAccent,
                                                          width: 3)),
                                                  child: Container(
                                                    height: height * 0.10,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white54,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          spreadRadius: 2,
                                                          blurRadius: 3,
                                                          offset: Offset(0,
                                                              3), // Altere o valor do offset para mover a sombra em diferentes direções
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.6,
                                                          child: Text(
                                                            "${userAdress[index].rua}, Nº ${userAdress[index].numero}, bairro ${userAdress[index].bairro['nome']}",
                                                            style: TextStyle(
                                                                fontSize: 19),
                                                          ),
                                                        ),
                                                        Container(
                                                            child: Icon(
                                                                Icons
                                                                    .check_circle_rounded,
                                                                color: Colors
                                                                    .greenAccent,
                                                                size: 36))
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      border: Border.all(
                                                          color: Colors.grey,
                                                          width: 1.5)),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 5,
                                                            vertical: 5),
                                                    height: height * 0.10,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white54),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        SizedBox(
                                                          width: width * 0.6,
                                                          child: Text(
                                                            "${userAdress[index].rua}, Nº ${userAdress[index].numero}, bairro ${userAdress[index].bairro['nome']}",
                                                            style: TextStyle(
                                                                fontSize: 19),
                                                          ),
                                                        ),
                                                        Container(
                                                            child: Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color:
                                                                    Colors.grey,
                                                                size: 32))
                                                      ],
                                                    ),
                                                  ),
                                                )),
                                    ],
                                  )),
                                );
                              }),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    height: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          child: Container(
                            child: Text(
                              "Escolha a forma de pagamento:",
                              style: GoogleFonts.nanumGothic(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF6c5c54),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.005),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            color: Colors.white54,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.95,
                                  child: DropdownButtonFormField(
                                    validator: (value) {
                                      if (value == null) {
                                        return;
                                      }
                                    },
                                    decoration: InputDecoration(
                                      label: Text('Pagamento',
                                          style: TextStyle(fontSize: 21)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    isExpanded: true,
                                    value: _selectedPayment,
                                    hint: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(_selectedPayment ??
                                          "Selecione a forma de pagamento:"),
                                    ),
                                    items: _payment
                                        .map(
                                          (pay) => DropdownMenuItem(
                                            value: pay["pay"].toString(),
                                            child: Text(pay["pay"].toString()),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        _selectedPayment = newValue;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _selectedPayment == "Pix"
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                              "Chave pix: @mercadodebebidaspeb",
                                              style: TextStyle(fontSize: 19)),
                                          InkWell(
                                            onTap: () async {
                                              await Clipboard.setData(ClipboardData(
                                                  text:
                                                      "@mercadodebebidaspeb"));
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03),
                                              child: Icon(Icons.content_copy),
                                            ),
                                          ),
                                        ],
                                      )),
                                )
                              : Container(),
                        ],
                      )),
                  SizedBox(height: 5),
                  SizedBox(
                    width: width * 0.95,
                    child: _selectedPayment != "Dinheiro"
                        ? TextFormField(
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                labelText: "Observação",
                                fillColor: Colors.white,
                                focusColor: Colors.white),
                            onChanged: (value) {
                              setState(() => _obs = value);
                            })
                        : TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                labelText: "Deseja informar o troco?",
                                hintText: "Ex: 50.00"),
                            onChanged: (value) {
                              setState(() => _obs = value);
                            }),
                  ),
                  isLoading
                      ? SizedBox(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: LoadingAnimationWidget.hexagonDots(
                                  color: Colors.black,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _finalValue >= _pontosConfig.valorDivisao &&
                              _pontosConfig.isActive != 0
                          ? Container(
                              width: width * 0.95,
                              height: MediaQuery.of(context).size.height / 12,
                              margin: EdgeInsets.only(bottom: 3),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: width * 0.7,
                                    child: Text(
                                      "Parabéns você ganhou " +
                                          _qtdPoints.toString() +
                                          " ponto(s) de desconto:",
                                      style: GoogleFonts.nanumGothic(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    margin: EdgeInsets.only(bottom: 50, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width,
                          height: MediaQuery.of(context).size.height / 25,
                          margin: EdgeInsets.only(bottom: 8),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Valor do frete",
                                style: GoogleFonts.nanumGothic(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              isLoading
                                  ? SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: LoadingAnimationWidget
                                                .hexagonDots(
                                              color: Colors.black,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Text(
                                      "R\$" + _valorFrete.toString(),
                                      style: GoogleFonts.nanumGothic(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        Container(
                          width: width,
                          height: MediaQuery.of(context).size.height / 12,
                          margin: EdgeInsets.only(bottom: 3),
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Valor total do pedido:",
                                style: GoogleFonts.nanumGothic(
                                  fontSize: 21,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              isLoading
                                  ? SizedBox(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: LoadingAnimationWidget
                                                .hexagonDots(
                                              color: Colors.black,
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _qtdPoints >= 1 &&
                                          _pontosConfig.isActive != 0
                                      ? Column(
                                          children: [
                                            Text(
                                              "R\$" +
                                                  _finalValue
                                                      .toStringAsFixed(2),
                                              style: GoogleFonts.nanumGothic(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationThickness: 1.8,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red),
                                            ),
                                            Text(
                                              "R\$" +
                                                  _finalResultWithDiscount
                                                      .toStringAsFixed(2),
                                              style: GoogleFonts.nanumGothic(
                                                  fontSize: 21,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          child: Text(
                                            "R\$" +
                                                _finalValue.toStringAsFixed(2),
                                            style: GoogleFonts.nanumGothic(
                                                fontSize: 21,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
                                          ),
                                        ),
                            ],
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: EdgeInsets.all(5),
                            child: ElevatedButton(
                                child: Text('Finalizar pedido'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Procesando...')),
                                    );
                                    getMessageClosedStore();
                                    guardarDadosEntrega();
                                    _qtdPoints >= 1 &&
                                            _pontosConfig.isActive != 0
                                        ? setState(() {
                                            _finalValue =
                                                _finalResultWithDiscount;
                                          })
                                        : setState(() {
                                            _finalValue = _finalValue;
                                          });
                                    cadastroPedido(
                                        _finalValue,
                                        _selectedPayment,
                                        _obs,
                                        dataUserProvider.adress[indexAdress].id,
                                        itensPedido);
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
