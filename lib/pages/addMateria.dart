import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';

class Addmateria extends StatefulWidget {
  final Function onAdd;
  const Addmateria({required this.onAdd, super.key});

  @override
  State<Addmateria> createState() => _AddmateriaState();
}

class _AddmateriaState extends State<Addmateria> {
  TextEditingController nmateriaController = TextEditingController();
  TextEditingController descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            //nombre materia
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Nombre de la materia"),

                  SizedBox(height: 5),

                  TextField(
                    controller: nmateriaController,
                    decoration: InputDecoration(hintText: "Materia"),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //descripcion
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Descripcion de la materia"),

                  SizedBox(height: 5),

                  TextField(
                    controller: descController,
                    decoration: InputDecoration(hintText: "Descripcion"),
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 220,
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            //BOTON AGREGAR
            FilledButton(
              onPressed: () {
                if (!validarInputs()) return;

                Materia m = Materia(
                  NMAT: nmateriaController.text.toLowerCase().trim(),
                  DESCRIPCION: descController.text.toLowerCase().trim(),
                );
                ControllerMateria().insertarMateria(m).then((r) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_outlined, color: Colors.green),
                          SizedBox(width: 4),
                          Text("Materia agregada correctamente"),
                        ],
                      ),
                    ),
                  );
                });
              },
              child: Text("Agregar materia", style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  bool validarInputs() {
    if (nmateriaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes ingresar un nombre para la materia")),
      );
      return false;
    }

    return true;
  }
}
