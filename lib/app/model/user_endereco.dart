// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: file_names

import 'dart:convert';

import 'bairro.dart';

class UserEndereco {
  int id;
  String rua;
  int numero;
  String? complemento;
  var bairro;

  UserEndereco(
      {required this.id,
      required this.rua,
      required this.numero,
      required this.complemento,
      required this.bairro});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro.toMap(),
    };
  }

  factory UserEndereco.fromMap(Map<String, dynamic> map) {
    return UserEndereco(
      id: map['id'] as int,
      rua: map['rua'] as String,
      numero: map['numero'] as int,
      complemento: map['complemento'] as String,
      bairro: Bairro.fromMap(map['bairro'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserEndereco.fromJson(String source) =>
      UserEndereco.fromMap(json.decode(source) as Map<String, dynamic>);
}
