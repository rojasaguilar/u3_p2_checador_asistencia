import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/components/horarioCard.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerHorario.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/pages/addHorario.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<Map<String, dynamic>> horarios = [];

  List<String> materias = [];
  List<String> profesores = [];

  // List<dynamic> filtros = [];

  int? asistencia;
  String? profesor;
  String? materia;

  ControllerHorario controllerHorario = ControllerHorario();
  ControllerProfesor controllerProfesor = ControllerProfesor();
  ControllerMateria controllerMateria = ControllerMateria();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _obtenerMaterias();
    _obtenerProfesores();
    actualizarHorarios();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext co) {
                    return Addhorario(
                      onAdd: () {
                        actualizarHorarios();
                      },
                    );
                  },
                ),
              );
            },
            child: Text("Agregar Horarios"),
          ),

          horarios.isEmpty
              ? Center(child: Text("No tienes horarios registrados"))
              //LISTA DE HORARIOS
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text("Horarios (${horarios.length})"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //FALTA/ASISTENCIA
                              DropdownButton<int>(
                                items: [
                                  DropdownMenuItem(
                                    child: Text("ASISTENCIA", style: TextStyle(fontSize: 11)),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text("FALTA", style: TextStyle(fontSize: 11)),
                                    value: 0,
                                  ),
                                ],
                                value: asistencia,
                                onChanged: (x) {
                                  setState(() {
                                    asistencia = x;
                                  });
                                  _filtrarMaterias();
                                },
                              ),

                              //PROFESORES
                              DropdownButton<String>(
                                items: profesores.map((profesor) => DropdownMenuItem<String>( value: profesor, child: Text(profesor, style: TextStyle(fontSize: 11),))).toList(),
                                value: profesor,
                                onChanged: (x) {
                                  setState(() {
                                    profesor = x;
                                  });
                                },
                              ),


                              //ELIMINAR FILTROS
                              IconButton(
                                onPressed: () {
                                  //LOGICA ELMINAR FILTROS
                                  setState(() {
                                    asistencia = null;
                                    profesor = null;
                                  });
                                  actualizarHorarios();
                                  return;
                                },
                                icon: Icon(CupertinoIcons.xmark, size: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          children: horarios
                              .map(
                                (horario) => Horariocard(
                                  onUpdate: () {
                                    actualizarHorarios();
                                  },
                                  horario: horario,
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

  void actualizarHorarios() async {
    final data = await controllerHorario.obtenerHorarios();

    setState(() {
      horarios = data;
    });
  }

  String _parseAsistencia(int asistencia) {
    return asistencia == 1 ? "ASISTENCIA" : 'FALTA';
  }

  void _obtenerProfesores() async {
    final data = await controllerProfesor.obtenerProfesores();
    setState(() {
      profesores.clear();
     data.forEach((profesor) => profesores.add(profesor.NOMBRE));
    });
  }

  void _obtenerMaterias() async {
    final data = await controllerMateria.obtenerMaterias();
    setState(() {
      data.forEach((materia) => materias.add(materia.NMAT));
    });
  }

  void _filtrarMaterias() async {
    final data = await   controllerHorario.filtrarHorario([asistencia, profesor, materia]);
    data.forEach((horario) => print(horario));
    setState(() {
      horarios = data;
    });
  }
}
