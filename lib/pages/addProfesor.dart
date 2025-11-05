import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';

class Addprofesor extends StatefulWidget {
  final Function onAdd;
  const Addprofesor({required this.onAdd, super.key});

  @override
  State<Addprofesor> createState() => _AddprofesorState();
}

class _AddprofesorState extends State<Addprofesor> {
  TextEditingController nombreController = TextEditingController();


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
            SizedBox(height: 20),

            //BOTON AGREGAR
            FilledButton(
              onPressed: () {
                if (!validarInputs()) return;

                Profesor p = Profesor(NPROFESOR: NPROFESOR, NOMBRE: NOMBRE, CARRERA: CARRERA)
                Controller().insertarMateria(m).then((r) {
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
    if (nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Debes ingresar un nombre para el profesor")),
      );
      return false;
    }

    return true;
  }
}
