import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerHorario.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/models/horario.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/pages/addHorario.dart';
import 'package:u3_p2_checador_asistencia/pages/addMateria.dart';
import 'package:u3_p2_checador_asistencia/pages/addProfesor.dart';

class Materias extends StatefulWidget {
  const Materias({super.key});

  @override
  State<Materias> createState() => _MateriasState();
}

class _MateriasState extends State<Materias> {
  List<Materia> materias = [];
  List<Profesor> profesores = [];
  List<Horario> horarios = [];

  ControllerMateria controllerMateria = ControllerMateria();
  ControllerProfesor controllerProfesor = ControllerProfesor();
  ControllerHorario controllerHorario = ControllerHorario();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
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

          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext co) {
                    return Addprofesor(
                      onAdd: () {
                        setState(() {
                          actualizarProfesores();
                        });
                      },
                    );
                  },
                ),
              );
            },
            child: Text("Agregar Profesor"),
          ),

          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext co) {
                    return Addhorario(
                      onAdd: () {
                        setState(() {
                          actualizarProfesores();
                        });
                      },
                    );
                  },
                ),
              );
            },
            child: Text("Agregar Horarios"),
          ),
        ],
      ),
    );
  }

  void actualizarMaterias() async {
    final materiasMap = await controllerMateria.obtenerMaterias();

    materias = materiasMap;

    materias.forEach((materia) => print("${materia.toJSON()} \n"));
  }

  void actualizarProfesores() async {
    final profesoresMap = await controllerProfesor.obtenerProfesores();

    profesores = profesoresMap;

    profesores.forEach((profesor) => print("${profesor.toJSON()} \n"));
  }

  void actualizarHorarios() async {
    horarios = await controllerHorario.obtenerHorarios();

    horarios.forEach((horario) => print("${horario.toJSON()} \n"));
  }
}
