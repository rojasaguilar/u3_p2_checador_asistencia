import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:u3_p2_checador_asistencia/pages/PageHorario.dart';

class Horariocard extends StatefulWidget {
  final Function onUpdate;
  final Map<String,dynamic> horario;
  const Horariocard({required this.onUpdate, required this.horario,  super.key});

  @override
  State<Horariocard> createState() => _HorariocardState();
}

class _HorariocardState extends State<Horariocard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //MANDAR A HORARIO
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (b) => Pagehorario(
              horario: widget.horario,
              onUpdate: widget.onUpdate
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              spreadRadius: 1.5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            //HORA Y MATERIA
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                //HORA
                Row(
                  children: [
                    Icon(Icons.timer),
                    SizedBox(width: 6),
                    Text(widget.horario['HORA']),
                  ],
                ),
                //MATERIA
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),
                    color: Colors.amberAccent[100],
                  ),
                  child: Text(
                    widget.horario['NMAT'],
                    style: TextStyle(fontSize: 11),
                  ),
                ),
              ],
            ),
            //PROFESOR
            Row(
              children: [
                Icon(Icons.person_outline),
                SizedBox(width: 6),
                Text(widget.horario['NOMBRE']),
              ],
            ),
            //EDIFICIO Y SALON
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      CupertinoIcons
                          .building_2_fill,
                    ),
                    SizedBox(width: 6),
                    Text(
                      "${widget.horario['EDIFICIO']} - ${widget.horario['SALON']}",
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(20),
                  ),
                  child:
                  widget.horario['ASISTENCIA'] == null
                      ? Text(
                    "Pendiente \n asistencia",
                    textAlign:
                    TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      Colors.amber[700],
                      fontWeight:
                      FontWeight.bold,
                    ),
                  )
                      : Text(
                    _parseAsistencia(
                      widget.horario['ASISTENCIA'],
                    ),
                    style: TextStyle(
                      fontSize: 11,
                      color:
                      widget.horario['ASISTENCIA'] ==
                          1
                          ? Colors.green
                          : Colors.red,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  String _parseAsistencia(int asistencia) {
    return asistencia == 1 ? "ASISTENCIA" : 'FALTA';
  }
}
