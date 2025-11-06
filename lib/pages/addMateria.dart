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
  ControllerMateria controllerMateria = ControllerMateria();

  final TextEditingController nmatController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Agregar Materia", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(
              controller: nmatController,
              labelText: "Clave de la materia (NMAT)",
              icon: Icons.vpn_key_outlined,
            ),
            const SizedBox(height: 15),
            _buildTextField(
              controller: descripcionController,
              labelText: "Descripción",
              icon: Icons.description_outlined,
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

                Materia m = Materia(
                  NMAT: nmatController.text,
                  DESCRIPCION: descripcionController.text,
                );

                controllerMateria.insertarMateria(m).then((r) {
                  if (r < 1) {
                    _showSnackBar(
                        "No se pudo registrar la materia", Icons.cancel_outlined, Colors.red);
                    return;
                  }
                  _showSnackBar(
                      "Materia registrada correctamente", Icons.check_outlined, Colors.green);
                  widget.onAdd();
                  Navigator.pop(context);
                });
              },
              child: const Text("Agregar Materia"),
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
    if (nmatController.text.isEmpty) {
      _showSnackBar(
          "La clave de la materia es obligatoria", Icons.warning_amber_rounded, Colors.amber);
      return false;
    }
    if (descripcionController.text.isEmpty) {
      _showSnackBar(
          "La descripción de la materia es obligatoria", Icons.warning_amber_rounded, Colors.amber);
      return false;
    }
    return true;
  }
}
