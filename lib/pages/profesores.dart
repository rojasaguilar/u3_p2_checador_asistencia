import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/pages/addProfesor.dart';
import 'package:u3_p2_checador_asistencia/pages/pageProfe.dart';

class Profesores extends StatefulWidget {
  const Profesores({super.key});

  @override
  State<Profesores> createState() => _ProfesoresState();
}

class _ProfesoresState extends State<Profesores> {
  List<Profesor> profesores = [];

  ControllerProfesor controllerProfesor = ControllerProfesor();

  List<String> carreras = [
    "Sistemas",
    "Mecatrónica",
    "Industrial",
    "Arquitectura",
    "Civil",
    // "Cualquiera"
  ];
  // String? carreraSeleccionada = "Cualquiera";
  String? carreraSeleccionada;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarProfesores();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
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
                    return Addprofesor(
                      onAdd: () {
                        actualizarProfesores();
                      },
                    );
                  },
                ),
              );
            },
            child: Text("Agregar Profesor"),
          ),

          profesores.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Profesores (${profesores.length})",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        DropdownButton<String>(
                          dropdownColor: Colors.amber[600],
                          hint: Text(
                            "Carrera",
                            style: TextStyle(fontSize: 13, color: Colors.white),
                          ),
                          value: carreraSeleccionada,
                          items: carreras
                              .map(
                                (carrera) => DropdownMenuItem<String>(
                                  child: Text(
                                    carrera,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                  ),
                                  value: carrera,
                                ),
                              )
                              .toList(),
                          onChanged: (x) {
                            setState(() {
                              carreraSeleccionada = x;
                            });
                            filtrarProfesoresPorCarrera();
                            return;
                          },
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              carreraSeleccionada = null;
                            });
                            actualizarProfesores();
                          },
                          icon: Icon(
                            CupertinoIcons.clear,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              //LISTA DE PROFES
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Profesores (${profesores.length})",
                            style: TextStyle(color: Colors.white),
                          ),
                          Row(
                            children: [
                              DropdownButton<String>(
                                dropdownColor: Colors.amber[600],
                                hint: Text(
                                  "Carrera",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                                value: carreraSeleccionada,
                                items: carreras
                                    .map(
                                      (carrera) => DropdownMenuItem<String>(
                                        child: Text(
                                          carrera,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                        ),
                                        value: carrera,
                                      ),
                                    )
                                    .toList(),
                                onChanged: (x) {
                                  setState(() {
                                    carreraSeleccionada = x;
                                  });
                                  filtrarProfesoresPorCarrera();
                                  return;
                                },
                              ),
                              SizedBox(width: 4),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    carreraSeleccionada = null;
                                  });
                                  actualizarProfesores();
                                },
                                icon: Icon(
                                  CupertinoIcons.clear,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: profesores
                              .map(
                                (profe) => ListTile(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (b) => Pageprofe(
                                          profe: profe,
                                          onUpdate: () {
                                            actualizarProfesores();
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  title: Text(
                                    "${profe.NOMBRE}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    "${profe.CARRERA}",
                                    style: TextStyle(color: Colors.white54),
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

  void actualizarProfesores() async {
    final profesoresMap = await controllerProfesor.obtenerProfesores();

    setState(() {
      profesores = profesoresMap;
    });

    profesores.forEach((profesor) => print("${profesor.toJSON()} \n"));
  }

  void filtrarProfesoresPorCarrera() async {
    final data = await controllerProfesor.filtrarPorCarrera(
      carreraSeleccionada!,
    );
    setState(() {
      profesores = data;
    });
  }
}
