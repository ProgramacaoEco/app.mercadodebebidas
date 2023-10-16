// ignore: import_of_legacy_library_into_null_safe
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:loja_mercado_de_bebidas/app/model/produto.dart';
import 'package:loja_mercado_de_bebidas/app/pesquisa/barra_pesquisa_view.dart';
import 'package:loja_mercado_de_bebidas/app/providers/campanhas_list.dart';
import 'package:loja_mercado_de_bebidas/app/providers/categorias_list.dart';
import 'package:loja_mercado_de_bebidas/app/providers/produtos_list.dart';
import 'package:loja_mercado_de_bebidas/app/usuario/usuario_controller.dart';
import 'package:loja_mercado_de_bebidas/app/widgets/navigation_drawer_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/bottomSheet.dart';
import '../widgets/cardsRedeSocial.dart';
import '../widgets/colors.dart';

import 'package:flutter/material.dart';

//declara um objeto hc da classe controladora HomeState, para ser usada dentro da HomeView

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  _HomeView createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  bool isLoadingDestaques = true;
  bool isLoadingCategorias = true;
  bool isLoadingCampanhas = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProdutosList>(context, listen: false)
        .index("")
        .then((value) => setState(() {
              isLoadingDestaques = false;
            }));
    Provider.of<CategoriasList>(context, listen: false)
        .index()
        .then((value) => setState(() {
              isLoadingCategorias = false;
            }));
    Provider.of<CampanhasList>(context, listen: false)
        .index()
        .then((value) => setState(() {
              isLoadingCampanhas = false;
            }));
    UsuarioController usuarioController = UsuarioController();
    usuarioController.verifyUserLoggedAndSetDataUser();
  }

  @override
  void dispose() {
    super.dispose();
    UsuarioController usuarioController = UsuarioController();
    usuarioController.verifyUserLoggedAndSetDataUser();
  }

  Cores cor = Cores();

  final formKey = GlobalKey<FormState>();
  //
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final providerProdutos = Provider.of<ProdutosList>(context);
    //
    final providerCategorias = Provider.of<CategoriasList>(context);
    //
    final providerCampanhas = Provider.of<CampanhasList>(context);
    //
    final size = MediaQuery.of(context).size;
    //
    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          toolbarHeight: MediaQuery.of(context).size.height >= 650
              ? MediaQuery.of(context).size.height / 13
              : MediaQuery.of(context).size.height / 11,
          leading: Builder(builder: (BuildContext context) {
            return IconButton(
                icon: const Icon(IconData(0xefa7, fontFamily: 'MaterialIcons'),
                    size: 21),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip:
                    MaterialLocalizations.of(context).openAppDrawerTooltip);
          }),
          actions: [
            Container(
              child: IconButton(
                icon: Icon(Icons.shopping_cart_rounded,
                    color: Colors.white, size: 21),
                onPressed: () {
                  Navigator.pushNamed(context, "/carrinho");
                },
              ),
            ),
          ],
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Cardsredesocial(),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(),
                  // height:MediaQuery.of(context).size.height / 3.6,
                  // width: MediaQuery.of(context).size.width / 1,
                  // decoration:  BoxDecoration(
                  // border: Border.all(width: 2, color: Color(cor.corTransp)),
                  //   color: Colors.white70,
                  //     ),

                  child: CarouselSlider(
                      options: CarouselOptions(
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 5),
                          scrollDirection: Axis.horizontal,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enlargeCenterPage: true,
                          //enlargeStrategy: CenterPageEnlargeStrategy.height,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 1000),
                          viewportFraction: 1),
                      items: isLoadingCampanhas ? [] : providerCampanhas.items),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, left: 5, right: 5),
                  decoration: BoxDecoration(
                    border:
                        Border.all(width: 2.5, color: Colors.blueGrey.shade100),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 7.2,
                  child: isLoadingCategorias
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          margin: EdgeInsets.only(top: 5),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: providerCategorias.items,
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: MediaQuery.of(context).size.height * 0.04,
                            child: Form(
                              key: formKey,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0,
                                          3), // Altere o valor do offset para mover a sombra em diferentes direções
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.search,
                                  onFieldSubmitted: (value) async {
                                    setState(() {
                                      isLoadingDestaques = true;
                                    });
                                    FocusScope.of(context).unfocus();
                                    await Provider.of<ProdutosList>(context,
                                            listen: false)
                                        .index(_searchController.text);
                                    setState(() {
                                      isLoadingDestaques = false;
                                    });
                                  },
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 19),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    hoverColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 20),
                                    labelText: 'Pesquisa...',
                                    labelStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                      borderSide: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Colors.black54,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )),
                        Container(
                          width: MediaQuery.of(context).size.height * 0.05,
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: Colors.grey[100],
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0,
                                    3), // Altere o valor do offset para mover a sombra em diferentes direções
                              ),
                            ],
                          ),
                          child: InkWell(
                            child: Icon(Icons.search_rounded,
                                color: Colors.black54),
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                isLoadingDestaques = true;
                              });
                              await Provider.of<ProdutosList>(context,
                                      listen: false)
                                  .index(_searchController.text);
                              setState(() {
                                isLoadingDestaques = false;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isLoadingDestaques
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
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
                    : providerProdutos.itemsCount == 0
                        ? Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.1),
                            child: const Center(
                                child: Text(
                              'Nenhum Produto Encontrado',
                              style: TextStyle(fontSize: 19),
                            )),
                          )
                        : Container(
                            // margin: EdgeInsets.only( left: 2, right: 2),
                            child: Wrap(
                              direction: Axis.horizontal,
                              alignment: WrapAlignment.spaceAround,
                              children: providerProdutos.cards,
                            ),
                          ),
                Container(
                    height: MediaQuery.of(context).size.height >= 800
                        ? MediaQuery.of(context).size.height / 14
                        : MediaQuery.of(context).size.height / 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
