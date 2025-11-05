import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/models/horario.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerHorario.dart';
import 'package:u3_p2_checador_asistencia/pages/addHorario.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<Horario> horarios = [];
  ControllerHorario controllerHorario = ControllerHorario();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext co) {
                    return Addhorario(
                      onAdd: () {
                        actualizarHorarios();
                      },
                    );
                  },
                ),
              );
            },
            child: Text("Agregar Horarios"),
          ),

          horarios.isEmpty
              ? Center(child: Text("No tienes horarios registrados"))
              //LISTA DE HORARIOS
              : Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Horarios (${horarios.length})"),
                      Expanded(
                        child: ListView(
                          children: horarios
                              .map(
                                (horario) => GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.indigoAccent[100],
                                    ),
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

  void actualizarHorarios() async {
    final data = await controllerHorario.obtenerHorarios();

    setState(() {
      horarios = data;
    });

    horarios.forEach((horario) => print("${horario.toJSON()} \n"));
  }
}
