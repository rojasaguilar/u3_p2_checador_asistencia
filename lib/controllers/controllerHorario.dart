import 'package:sqflite/sqflite.dart';
import 'package:u3_p2_checador_asistencia/models/horario.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerHorario {
  final BD _bd = BD();

  Future<int> insertarHorario(Horario h) async {
    final db = await _bd.conectarDB();
    return db.insert('HORARIO', h.toJSON());
  }

  Future<List<Horario>> obtenerHorarios() async {
    final db = await _bd.conectarDB();
    final horariosMap = await db.query('HORARIO');
    return horariosMap.map((horario) => Horario.fromJSON(horario)).toList();
  }
}
