import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerHorario.dart';

class Pagehorario extends StatefulWidget {
  final Map<String, dynamic> horario;
  final Function onUpdate;
  const Pagehorario({required this.onUpdate, required this.horario, super.key});

  @override
  State<Pagehorario> createState() => _PagehorarioState();
}

class _PagehorarioState extends State<Pagehorario> {
  ControllerHorario controllerHorario = ControllerHorario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.horario['NMAT'], style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F1F1F),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             _buildInfoSection(
                icon: Icons.person_outline, title: "Profesor", value: widget.horario['NOMBRE']),
            const SizedBox(height: 15),
            _buildInfoSection(
                icon: Icons.timer_outlined, title: "Hora", value: widget.horario['HORA']),
            const SizedBox(height: 15),
            _buildInfoSection(
                icon: CupertinoIcons.building_2_fill,
                title: "Ubicación",
                value: "${widget.horario['EDIFICIO']} - ${widget.horario['SALON']}"),
            const SizedBox(height: 30),
            const Divider(color: Colors.grey),
            const SizedBox(height: 20),

            // Conditional rendering for asistencia
            widget.horario['ASISTENCIA'] == null
                ? Column(
                  children: [
                     Text(
                      "Registrar Asistencia",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAsistenciaButton(
                            label: "Asistencia",
                            color: Colors.green,
                            onPressed: () => _confirmarRegistro(true),
                          ),
                          _buildAsistenciaButton(
                            label: "Falta",
                            color: Colors.red,
                            onPressed: () => _confirmarRegistro(false),
                          ),
                        ],
                      ),
                  ],
                )
                : Center(
                  child: Card(
                    color: const Color(0xFF1F1F1F),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text(
                        _parseAsistencia(widget.horario['ASISTENCIA']),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.horario['ASISTENCIA'] == 1 ? Colors.green : Colors.red,
                          ), 
                      ),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

    Widget _buildInfoSection(
      {required IconData icon, required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey[400], size: 20),
            const SizedBox(width: 8),
            Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Text(value,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildAsistenciaButton(
      {required String label, required Color color, required VoidCallback onPressed}) {
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


  void _confirmarRegistro(bool esAsistencia) async {
    final confirm = await _showStyledDialog(
      title: "Confirmar ${esAsistencia ? 'Asistencia' : 'Falta'}",
      content: "¿Estás seguro de registrar la ${esAsistencia ? 'asistencia' : 'falta'} del profesor ${widget.horario['NOMBRE']}?",
    );

    if (confirm == true) {
      if (esAsistencia) {
        _marcarAsistencia();
      } else {
        _marcarFalta();
      }
    }
  }

  Future<bool?> _showStyledDialog({required String title, required String content}) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1F1F1F),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          content: Text(content, style: const TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.white70)),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text("Confirmar", style: TextStyle(color: Colors.amber)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
  }

  String getFecha() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }

  String _parseAsistencia(int asistencia) {
    return asistencia == 1 ? "ASISTENCIA" : 'FALTA';
  }

  void _marcarFalta() {
    controllerHorario
        .modificarAsistencia(widget.horario['NHORARIO'], getFecha(), 0)
        .then((r) {
      if (r > 0) {
        _showSnackBar("Falta confirmada", Icons.check_circle_outline, Colors.green);
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        _showSnackBar("No se pudo registrar la falta", Icons.error_outline, Colors.red);
      }
    }).catchError((error) {
      _showSnackBar("Error al registrar la falta", Icons.error_outline, Colors.red);
    });
  }

  void _marcarAsistencia() {
    controllerHorario
        .modificarAsistencia(widget.horario['NHORARIO'], getFecha(), 1)
        .then((r) {
      if (r > 0) {
        _showSnackBar("Asistencia confirmada", Icons.check_circle_outline, Colors.green);
        widget.onUpdate();
        Navigator.pop(context);
      } else {
        _showSnackBar("No se pudo registrar la asistencia", Icons.error_outline, Colors.red);
      }
    }).catchError((error) {
      _showSnackBar("Error al registrar la asistencia", Icons.error_outline, Colors.red);
    });
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
