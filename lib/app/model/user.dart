// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class User {
  String nome;
  String cpf;
  String telefone;
  var enderecoEntrega;

  User({
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      nome: map['nome'] as String,
      cpf: map['cpf'] as String,
      telefone: map['telefone'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);
}
