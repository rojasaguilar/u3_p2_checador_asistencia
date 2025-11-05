import 'package:u3_p2_checador_asistencia/models/horario.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerHorario {
  final BD _bd = BD();

  Future<int> insertarHorario(Horario h) async {
    final db = await _bd.conectarDB();
    return db.insert('HORARIO', h.toJSON());
  }

  Future<List<Map<String, dynamic>>> obtenerHorarios() async {
    final db = await _bd.conectarDB();
    final data = await db.rawQuery('''
    SELECT h.NHORARIO, h.HORA, h.EDIFICIO, h.NMAT, h.SALON, p.NOMBRE
    FROM HORARIO h
    INNER JOIN PROFESOR p ON (p.NPROFESOR = h.NPROFESOR) 
    ''', []);
    return data;
  }
}
