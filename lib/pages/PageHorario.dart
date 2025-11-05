import 'package:flutter/material.dart';

class Pagehorario extends StatefulWidget {
  final Map<String, dynamic> horario;
  final Function onUpdate;
  const Pagehorario({required this.onUpdate, required this.horario, super.key});

  @override
  State<Pagehorario> createState() => _PagehorarioState();
}

class _PagehorarioState extends State<Pagehorario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Column(

    ));
  }
}
