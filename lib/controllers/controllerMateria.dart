import 'package:sqflite/sqflite.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerMateria {
  final BD _bd = BD();

  Future<int> insertarMateria(Materia m) async {
    final db = await _bd.conectarDB();
    return db.insert('MATERIA', m.toJSON());
  }

  Future<List<Materia>> obtenerMaterias() async {
    final db = await _bd.conectarDB();
    final List<Map<String, dynamic>> materiasMap = await db.query('MATERIA');
    return materiasMap.map((materia) => Materia.fromJSON(materia)).toList();
  }

  Future<Materia?> obtenerMateria(String NMAT) async {
    final db = await _bd.conectarDB();

    final materias = await db.rawQuery('SELECT * FROM MATERIA WHERE NMAT = ?', [
      NMAT,
    ]);

    if(materias.isEmpty){
      return Materia.fromJSON(materias.first);
    }
    return null;
  }

  Future<int> eliminarMateria(String NMAT) async {
    final db = await _bd.conectarDB();
    return db.rawDelete(
      '''
      DELETE FROM MATERIA WHERE NMAT = ?
      ''',
      [NMAT],
    );
  }
}
