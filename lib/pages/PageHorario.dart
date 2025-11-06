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
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            widget.horario['ASISTENCIA'] == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FilledButton(
                        onPressed: () async {
                          final dialogRes = await showDialog(
                            context: context,
                            builder: (b) => AlertDialog(
                              title: Text("Confirmar asistencia?"),
                              content: Text(
                                "Deseas confirmar la asistencia del profe ${widget.horario['NOMBRE']}"
                                " para esta clase?",
                              ),
                              actions: [
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: Text("Si"),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, 0);
                                  },
                                  child: Text("NO"),
                                ),
                              ],
                            ),
                          );

                          if (dialogRes == 1) {
                            _marcarAsistencia();
                            return;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.check_outlined, color: Colors.green),
                            SizedBox(width: 5),
                            Text("Registrar \n asistencia"),
                          ],
                        ),
                      ),
                      //FALTA
                      FilledButton(
                        onPressed: () async {
                          final dialogRes = await showDialog(
                            context: context,
                            builder: (b) => AlertDialog(
                              title: Text("Confirmar FALTA?"),
                              content: Text(
                                "Deseas confirmar la FALTA del profe ${widget.horario['NOMBRE']}"
                                " para esta clase?",
                              ),
                              actions: [
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, 1);
                                  },
                                  child: Text("Si"),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Navigator.pop(context, 0);
                                  },
                                  child: Text("NO"),
                                ),
                              ],
                            ),
                          );

                          if (dialogRes == 1) {
                            _marcarFalta();
                            return;
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 5),
                            Text("Registrar \n falta"),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.amberAccent[100],
                    ),
                    child: Text(
                      _parseAsistencia(widget.horario['ASISTENCIA']),
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String getFecha() {
    DateTime date = DateTime.now();
    return date.toString().substring(0, 10);
  }

  String _parseAsistencia(int asistencia) {
    return asistencia == 1 ? "ASISTENCIA" : 'FALTA';
  }

  void _marcarFalta() {
    controllerHorario
        .modificarAsistencia(widget.horario['NHORARIO'], getFecha(), 0)
        .then((r) {
          if (r > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_outlined, color: Colors.green),
                    SizedBox(width: 5),
                    Text("FALTA confirmada"),
                  ],
                ),
              ),
            );
            widget.onUpdate();
            Navigator.pop(context);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "No se pudo registrar la asistencia, intente de nuevo mas tarde",
                  ),
                ],
              ),
            ),
          );
          return;
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "No se pudo registrar la FALTA, intente de nuevo mas tarde",
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _marcarAsistencia() {
    controllerHorario
        .modificarAsistencia(widget.horario['NHORARIO'], getFecha(), 1)
        .then((r) {
          if (r > 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_outlined, color: Colors.green),
                    SizedBox(width: 5),
                    Text("Asistencia confirmada"),
                  ],
                ),
              ),
            );
            widget.onUpdate();
            Navigator.pop(context);
            return;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "No se pudo registrar la asistencia, intente de nuevo mas tarde",
                  ),
                ],
              ),
            ),
          );
          widget.onUpdate();
          Navigator.pop(context);
          return;
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.cancel_outlined, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "No se pudo registrar la asistencia, intente de nuevo mas tarde",
                  ),
                ],
              ),
            ),
          );
        });
  }
}
