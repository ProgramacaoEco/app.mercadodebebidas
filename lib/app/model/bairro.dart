// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Bairro {
  int id;
  String nome;
  double valorFrete;

  Bairro(
    {
      required this.id,
      required this.nome,
      required this.valorFrete
    }
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id_bairro': id,
      'nome': nome,
      'valor_frete': valorFrete,
    };
  }

  factory Bairro.fromMap(Map<String, dynamic> map) {
    return Bairro(
     id: map['id_bairro'] as int,
     nome: map['nome'] as String,
     valorFrete: map['valor_frete'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bairro.fromJson(String source) => Bairro.fromMap(json.decode(source) as Map<String, dynamic>);
}
