import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/pages/horarios.dart';
import 'package:u3_p2_checador_asistencia/pages/materias.dart';
import 'package:u3_p2_checador_asistencia/pages/profesores.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indice = 0;

  final List<Widget> _paginas = [
    Materias(),
    Horarios(),
    Profesores(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Checador de Asistencia")),
      body: _paginas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (index) => setState(() => _indice = index),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Materias"),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: "Horarios",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Maestros"),
        ],
      ),
    );
  }
}
