import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/components/gridHours.dart';
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
  String? horaSeleccionada;
  String? edificio;
  String? salon;

  Map<String, List<String>> edificiosAulas = {
    "UD": ['A','B','C','D'],
    'UVP': ['E','F','G','H'],
    'LAB': ['L1','L2','L3'],
    'BASTON': ['A1','A2','A3','A4','A5'],
    'LICBI': ['J','K','L','M','N'],
    'MECALAB': ['J1','J2','K1','K2','K3'],
  };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerProfesores();
    obtenerMaterias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(padding: EdgeInsets.all(20), child: ListView(
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
                      value: profesor,
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

          SizedBox(height: 20),

          //MATERIAS
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
                      value: materia,
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

          SizedBox(height: 20),

          //HORA
          Gridhours(
            setHour: (String hour) {
              setState(() {
                horaSeleccionada = hour;
                print(horaSeleccionada);
              });
            },
          ),

          SizedBox(height: 20),

          //EDIFICIO
          DropdownButton<String>(
            value: edificio,
            items: edificiosAulas.keys
                .map(
                  (edi) =>
                  DropdownMenuItem<String>(child: Text(edi), value: edi),
            )
                .toList(),
            onChanged: (x) {
              setState(() {
                edificio = x;
              });
            },
          ),

          //SALON
          DropdownButton<String>(
            value: (salon != null && edificiosAulas[edificio]?.contains(salon) == true)
                ? salon
                : null, // Evita error si el salón anterior ya no existe
            hint: const Text("Selecciona un salón"),
            items: (edificio == null || edificio!.isEmpty)
                ? []
                : edificiosAulas[edificio]!
                .map(
                  (s) {
                return DropdownMenuItem<String>(
                  value: s,
                  child: Text(s),
                );
              },
            )
                .toList(),
            onChanged: (x) {
              setState(() {
                salon = x;
              });
            },
          ),

          //AGREGAR HORARIO
          FilledButton(onPressed: () {
            //LOGICA AGREGAR HORARIO
            widget.onAdd();
          }, child: Text("Agregar horario")),
        ],
      ),)
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
