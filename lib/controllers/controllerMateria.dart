import 'package:sqflite/sqflite.dart';
import 'package:u3_p2_checador_asistencia/models/materia.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerMateria {
  Future<int> insertarMateria(Materia m) async {
    Database db = await BD().conectarDB();
    return db.insert('MATERIA', m.toJSON());
  }

  Future<List<Materia>> obtenerMaterias() async {
    Database db = await BD().conectarDB();
    final List<Map<String, dynamic>> materiasMap = await db.query('MATERIA');
    return materiasMap.map((materia) => Materia.fromJSON(materia)).toList();
  }

  Future<Materia> obtenerMateria(String NMAT) async {
    Database db = await BD().conectarDB();

    final materias = await db.rawQuery('SELECT * FROM MATERIA WHERE NMAT = ?', [
      NMAT,
    ]);

    return Materia.fromJSON(materias[0]);
  }

  Future<int> eliminarMateria(String NMAT) async {
    Database db = await BD().conectarDB();
    return db.rawDelete(
      '''
      DELETE FROM MATERIA WHERE NMAT = ?
      ''',
      [NMAT],
    );
  }
}
