import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/pages/addMateria.dart';

class Materias extends StatefulWidget {
  const Materias({super.key});

  @override
  State<Materias> createState() => _MateriasState();
}

class _MateriasState extends State<Materias> {
  List<Materia> materias = [];

  ControllerMateria controllerMateria = ControllerMateria();

  @override
  void initState() {
    super.initState();
    actualizarMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.amber[600],
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext co) {
                    return Addmateria(
                      onAdd: () {
                        setState(() {
                          actualizarMaterias();
                        });
                      },
                    );
                  },
                ),
              );
            },
            child: const Text("Agregar materia"),
          ),
          const SizedBox(height: 20),
          materias.isEmpty
              ? const Center(
                  child: Text(
                  "No tienes materias registradas",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ))
              //LISTA DE MATERIAS
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Materias (${materias.length})",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          children: materias
                              .map(
                                (materia) => Card(
                                  color: const Color(0xFF1F1F1F),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: ListTile(
                                    leading: Icon(Icons.book,color: Colors.amber[600],),
                                    title: Text(
                                      materia.NMAT,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      materia.DESCRIPCION,
                                      style:
                                          TextStyle(color: Colors.grey[400]),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  void actualizarMaterias() async {
    final materiasMap = await controllerMateria.obtenerMaterias();

    setState(() {
      materias = materiasMap;
    });

    // materias.forEach((materia) => print("${materia.toJSON()} \n"));
  }
}
