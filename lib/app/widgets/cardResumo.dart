// ignore_for_file: file_names
import 'package:loja_mercado_de_bebidas/app/model/itens_pedido.dart';
import 'package:loja_mercado_de_bebidas/utils/constants.dart';

import '../../database/database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardResumo extends StatelessWidget {
  final ItensPedido itensPedido;
  const CardResumo(this.itensPedido, {Key? key}) : super(key: key);

  double fontes(BuildContext context) {
    return MediaQuery.of(context).size.height >= 800 ? 16.0 : 15.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                itensPedido.descricaoProduto,
                style: GoogleFonts.nanumGothic(
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.height >= 800 ? 17 : 16,
                ),
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quantidade: ${itensPedido.quantidade}",
                        style: GoogleFonts.nanumGothic(
                          fontSize: fontes(context),
                        ),
                      ),
                      Text(
                        "Tamanho: ${itensPedido.tamanho}",
                        style: GoogleFonts.nanumGothic(
                          fontSize: itensPedido.tamanho.length >= 15 ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Valor unitário:',
                        style: GoogleFonts.nanumGothic(
                          fontSize: MediaQuery.of(context).size.height >= 630
                              ? 16
                              : 14,
                        ),
                      ),
                      Text(
                        "R\$ ${itensPedido.valor.toStringAsFixed(2).replaceAll(".", ",")}",
                        style: GoogleFonts.nanumGothic(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: MediaQuery.of(context).size.height >= 630
                              ? 16
                              : 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
