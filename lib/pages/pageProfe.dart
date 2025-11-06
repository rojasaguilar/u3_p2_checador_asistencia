import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';

class Pageprofe extends StatefulWidget {
  final Profesor profe;
  final Function onUpdate;
  const Pageprofe({required this.onUpdate, required this.profe, super.key});

  @override
  State<Pageprofe> createState() => _PageprofeState();
}

class _PageprofeState extends State<Pageprofe> {
  bool isEditing = false;

  final TextEditingController nombreController = TextEditingController();
  ControllerProfesor controllerProfesor = ControllerProfesor();

  String? carreraSeleccionada;

  final List<String> carreras = [
    "Sistemas",
    "Mecatrónica",
    "Industrial",
    "Arquitectura",
    "Civil",
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.profe.CARRERA);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          widget.profe.NPROFESOR,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        actions: [
          isEditing
              ? IconButton(
                  onPressed: () async {
                    if (!validarInputs()) return;

                    final confUpdate = await _showStyledDialog(
                      title: "Editar Profesor?",
                      content: "Seguro que quieres editar el profesor?",
                    );

                    if (confUpdate == true) {
                      Profesor p = Profesor.fromDB(
                        widget.profe.NPROFESOR,
                        nombreController.text,
                        carreraSeleccionada!,
                      );

                      controllerProfesor
                          .actualizarProfe(p)
                          .then((r) {
                            print(r);
                            if (r > 0) {
                              _showSnackBar(
                                "Profe actualizado correctamente",
                                Icons.check,
                                Colors.green,
                              );
                              return;
                            }
                            _showSnackBar(
                              "No se pudo actualizar al profesor",
                              Icons.cancel_outlined,
                              Colors.red,
                            );
                            return;
                          })
                          .catchError((error) {
                            _showSnackBar(
                              error,
                              Icons.cancel_outlined,
                              Colors.red,
                            );
                          });
                      setState(() {
                        // Actualizar el objeto del widget
                        widget.profe.NOMBRE = p.NOMBRE;
                        widget.profe.CARRERA = p.CARRERA;

                        // Actualizar los controllers
                        nombreController.text = p.NOMBRE;
                        carreraSeleccionada = p.CARRERA;

                        isEditing = false;
                      });
                      widget.onUpdate();
                    }
                  },
                  icon: Icon(Icons.check_outlined, size: 20),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      carreraSeleccionada = widget.profe.CARRERA;
                      nombreController.text = widget.profe.NOMBRE;
                      isEditing = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    color: Colors.amber[600],
                    child: Text(
                      "Editar",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
        ],
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: isEditing
          ? Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildTextField(
                    controller: nombreController,
                    labelText: "Nombre completo",
                    icon: Icons.person_outline,
                  ),
                  SizedBox(height: 20),

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
                  const SizedBox(height: 20),

                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber[600],
                      foregroundColor: Colors.black,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async{
                      final confUpdate = await _showStyledDialog(
                        title: "Eliminar Profesor?",
                        content: "Seguro que quieres ELIMINAR el profesor? esto eliminara horarios asignados con el",
                      );

                      if (confUpdate == true) {

                        controllerProfesor
                            .eliminarProfe(widget.profe.NPROFESOR)
                            .then((r) {
                          print(r);
                          if (r > 0) {
                            _showSnackBar(
                              "Profe ELIMINADO correctamente",
                              Icons.check,
                              Colors.green,
                            );
                            return;
                          }
                          _showSnackBar(
                            "No se pudo ELIMINAR al profesor",
                            Icons.cancel_outlined,
                            Colors.red,
                          );
                          return;
                        })
                            .catchError((error) {
                          _showSnackBar(
                            error,
                            Icons.cancel_outlined,
                            Colors.red,
                          );
                        });
                        widget.onUpdate();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Eliminar Profesor"),
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection(
                    icon: Icons.person_outline,
                    title: "Nombre",
                    value: widget.profe.NOMBRE,
                  ),
                  const SizedBox(height: 25),
                  _buildInfoSection(
                    icon: Icons.bookmark_border_outlined,
                    title: "Carrera",
                    value: widget.profe.CARRERA,
                  ),
                  const SizedBox(height: 25),
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

  Widget _buildInfoSection({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAsistenciaButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1F1F1F),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: Colors.grey[800]!),
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Future<bool?> _showStyledDialog({
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(content, style: const TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white70),
              ),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text(
                "Confirmar",
                style: TextStyle(color: Colors.amber),
              ),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  bool validarInputs() {
    if (nombreController.text.trim().isEmpty) {
      _showSnackBar(
        "Debes ingresar un nombre para el profesor",
        Icons.warning_amber_rounded,
        Colors.amber,
      );
      return false;
    }
    if (carreraSeleccionada == null) {
      _showSnackBar(
        "Debes seleccionar una carrera",
        Icons.warning_amber_rounded,
        Colors.amber,
      );
      return false;
    }
    return true;
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
}
