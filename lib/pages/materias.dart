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
    // TODO: implement initState
    super.initState();
    actualizarMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
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
          child: Text("Agregar materia"),
        ),

        materias.isEmpty
            ? Center(child: Text("No tienes materias registradas"))
            //LISTA DE MATERIAS
            : Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Materias (${materias.length})"),
                    Expanded(
                      child: ListView(
                        children: materias
                            .map(
                              (materia) => ListTile(
                                title: Text("${materia.NMAT}"),
                                subtitle: Text("${materia.DESCRIPCION}"),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }

  void actualizarMaterias() async {
    final materiasMap = await controllerMateria.obtenerMaterias();

    setState(() {
      materias = materiasMap;
    });

    materias.forEach((materia) => print("${materia.toJSON()} \n"));
  }
}
