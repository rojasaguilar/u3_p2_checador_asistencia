import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';

class Addhorario extends StatefulWidget {
  final Function onAdd;
  const Addhorario({required this.onAdd, super.key});

  @override
  State<Addhorario> createState() => _AddhorarioState();
}

class _AddhorarioState extends State<Addhorario> {
  ControllerProfesor controllerProfesor = ControllerProfesor();
  ControllerMateria controllerMateria = ControllerMateria();

  List<Profesor> profesores = [];
  List<Materia> materias = [];

  Profesor? profesorSeleccionado;
  Materia? materiaSeleccionada;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerProfesores();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [

          //PROFESOR
          Container(
            child: Column(
              children: [
                Text("Profesor"),
                DropdownButton<Profesor>(
                  value: profesorSeleccionado,
                  items: profesores
                      .map(
                        (profesor) => DropdownMenuItem<Profesor>(
                          child: Text(profesor.NOMBRE),
                          value: profesor
                        ),
                      )
                      .toList(),
                  onChanged: (x) {
                  setState(() {
                    profesorSeleccionado = x;
                  });
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: 20,),

          //PROFESOR
          Container(
            child: Column(
              children: [
                Text("Materia"),
                DropdownButton<Materia>(
                  value: materiaSeleccionada,
                  items: materias
                      .map(
                        (materia) => DropdownMenuItem<Materia>(
                        child: Text(materia.NMAT),
                        value: materia
                    ),
                  )
                      .toList(),
                  onChanged: (x) {
                    setState(() {
                      materiaSeleccionada = x;
                    });
                  },
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  void obtenerProfesores() async {
    final data = await controllerProfesor.obtenerProfesores();
    setState(() {
      profesores = data;
    });
  }

  void obtenerMaterias() async {
    final data = await controllerMateria.obtenerMaterias();
    setState(() {
      materias = data;
    });
  }
}
