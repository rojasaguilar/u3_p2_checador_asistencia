import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';

class Addprofesor extends StatefulWidget {
  final Function onAdd;
  const Addprofesor({required this.onAdd, super.key});

  @override
  State<Addprofesor> createState() => _AddprofesorState();
}

class _AddprofesorState extends State<Addprofesor> {
  TextEditingController nombreController = TextEditingController();
  String? carreraSeleccionada;

  List<String> carreras = [
    "Sistemas",
    "Mecatrónicia",
    "Industrial",
    "Arquitectura",
    "Civil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //nombre profesor
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nombre del profesor"),

                  SizedBox(height: 5),

                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(hintText: "Nombre"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //CARRERA
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Carrera"),

                  SizedBox(height: 5),

                  DropdownButton(
                    items: carreras
                        .map(
                          (carrera) => DropdownMenuItem(
                            child: Text(carrera),
                            value: carrera,
                          ),
                        )
                        .toList(),
                    onChanged: (x) {
                      setState(() {
                        carreraSeleccionada = x;
                      });
                    },
                    value: carreraSeleccionada,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //BOTON AGREGAR
            FilledButton(
              onPressed: () {
                if (!validarInputs()) return;

                Profesor p = Profesor(
                  NOMBRE: nombreController.text.trim().toLowerCase(),
                  CARRERA: carreraSeleccionada!,
                );
                ControllerProfesor().insertarProfesor(p).then((r) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_outlined, color: Colors.green),
                          SizedBox(width: 4),
                          Text("Profesor agregado correctamente"),
                        ],
                      ),
                    ),
                  );
                });

                widget.onAdd();
                Navigator.pop(context);
              },
              child: Text("Agregar Profesor", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  bool validarInputs() {
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes ingresar un nombre para el profesor")),
      );
      return false;
    }

    return true;
  }
}
