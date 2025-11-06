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
  final TextEditingController nombreController = TextEditingController();
  String? carreraSeleccionada;

  final List<String> carreras = [
    "Sistemas",
    "Mecatrónica",
    "Industrial",
    "Arquitectura",
    "Civil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Agregar Profesor", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: nombreController,
              labelText: "Nombre completo",
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 20),
            _buildDropdown<String>(
              hint: "Selecciona una carrera",
              value: carreraSeleccionada,
              items: carreras.map((carrera) {
                return DropdownMenuItem<String>(
                  value: carrera,
                  child: Text(carrera),
                );
              }).toList(),
              onChanged: (x) {
                setState(() {
                  carreraSeleccionada = x;
                });
              },
            ),
            const SizedBox(height: 40),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.amber[600],
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                if (!validarInputs()) return;

                Profesor p = Profesor(
                  NOMBRE: nombreController.text.trim(),
                  CARRERA: carreraSeleccionada!,
                );

                ControllerProfesor().insertarProfesor(p).then((r) {
                  if (r > 0) {
                    _showSnackBar("Profesor agregado correctamente",
                        Icons.check_circle_outline, Colors.green);
                    widget.onAdd();
                    Navigator.pop(context);
                  } else {
                     _showSnackBar("Error al agregar profesor",
                        Icons.error_outline, Colors.red);
                  }
                });
              },
              child: const Text("Agregar Profesor"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1F1F1F),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey[600]),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[800]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.amber[600]!),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String hint,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          dropdownColor: const Color(0xFF1F1F1F),
          style: const TextStyle(color: Colors.white),
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
        ),
      ),
    );
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1F1F1F),
        content: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(message, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  bool validarInputs() {
    if (nombreController.text.trim().isEmpty) {
      _showSnackBar("Debes ingresar un nombre para el profesor",
          Icons.warning_amber_rounded, Colors.amber);
      return false;
    }
    if (carreraSeleccionada == null) {
      _showSnackBar(
          "Debes seleccionar una carrera", Icons.warning_amber_rounded, Colors.amber);
      return false;
    }
    return true;
  }
}
