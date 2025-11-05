import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/pages/addProfesor.dart';

class Profesores extends StatefulWidget {
  const Profesores({super.key});

  @override
  State<Profesores> createState() => _ProfesoresState();
}

class _ProfesoresState extends State<Profesores> {
  List<Profesor> profesores = [];

  ControllerProfesor controllerProfesor = ControllerProfesor();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarProfesores();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(20), child: Column(
      children: [
        FilledButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext co) {
                  return Addprofesor(
                    onAdd: () {
                      actualizarProfesores();
                    },
                  );
                },
              ),
            );
          },
          child: Text("Agregar Profesores"),
        ),

        profesores.isEmpty
            ? Center(child: Text("No tienes profesores registrados"))
        //LISTA DE PROFES
            : Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Profesores (${profesores.length})"),
              Expanded(
                child: ListView(
                  children: profesores
                      .map(
                        (profe) => ListTile(
                      title: Text("${profe.NOMBRE}"),
                      subtitle: Text("${profe.CARRERA}"),
                    ),
                  )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  void actualizarProfesores() async {
    final profesoresMap = await controllerProfesor.obtenerProfesores();

    setState(() {
      profesores = profesoresMap;
    });

    profesores.forEach((profesor) => print("${profesor.toJSON()} \n"));
  }
}
