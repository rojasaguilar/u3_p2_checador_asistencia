import 'package:flutter/cupertino.dart';
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

  final List<String> carreras = [
    "Sistemas",
    "Mecatrónica",
    "Industrial",
    "Arquitectura",
    "Civil",
  ];
  String? carreraSeleccionada;

  @override
  void initState() {
    super.initState();
    actualizarProfesores();
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
                    return Addprofesor(
                      onAdd: () {
                        actualizarProfesores();
                      },
                    );
                  },
                ),
              );
            },
            child: const Text("Agregar Profesor"),
          ),
          const SizedBox(height: 20),
          // FILTROS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Profesores (${profesores.length})",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  DropdownButton<String>(
                    hint: Text("Carrera",
                        style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                    value: carreraSeleccionada,
                    dropdownColor: const Color(0xFF1F1F1F),
                    style: const TextStyle(color: Colors.white),
                    icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
                    items: carreras
                        .map(
                          (carrera) => DropdownMenuItem<String>(
                            value: carrera,
                            child: Text(carrera, style: const TextStyle(fontSize: 13)),
                          ),
                        )
                        .toList(),
                    onChanged: (x) {
                      setState(() {
                        carreraSeleccionada = x;
                      });
                      filtrarProfesoresPorCarrera();
                    },
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        carreraSeleccionada = null;
                      });
                      actualizarProfesores();
                    },
                    icon: Icon(CupertinoIcons.clear, size: 20, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // LISTA DE PROFESORES
          Expanded(
            child: profesores.isEmpty
                ? const Center(
                    child: Text(
                      "No hay profesores registrados",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : ListView(
                    children: profesores
                        .map(
                          (profe) => Card(
                            color: const Color(0xFF1F1F1F),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                profe.NOMBRE,
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                profe.CARRERA,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
    // profesores.forEach((profesor) => print("${profesor.toJSON()} \n"));
  }

  void filtrarProfesoresPorCarrera() async {
    if (carreraSeleccionada == null) return;
    final data = await controllerProfesor.filtrarPorCarrera(
      carreraSeleccionada!,
    );
    setState(() {
      profesores = data;
    });
  }
}
