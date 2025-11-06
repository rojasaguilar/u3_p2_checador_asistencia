import 'package:u3_p2_checador_asistencia/models/profesor.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerProfesor {
  final BD _bd = BD();

  Future<int> insertarProfesor(Profesor p) async {
    final db = await _bd.conectarDB();
    return db.insert('PROFESOR', p.toJSON());
  }

  Future<List<Profesor>> obtenerProfesores() async {
    final db = await _bd.conectarDB();
    final profesoresMap = await db.query('PROFESOR');
    return profesoresMap
        .map((profesor) => Profesor.fromJSON(profesor))
        .toList();
  }

  Future<List<Profesor>> filtrarPorCarrera(String carrera) async {
    final db = await _bd.conectarDB();
    final profesoresMap = await db.rawQuery(''' 
    SELECT * FROM PROFESOR WHERE CARRERA  = ?
    ''',
      [carrera],
    );
    return profesoresMap
        .map((profesor) => Profesor.fromJSON(profesor))
        .toList();
  }

  // Future<Profesor> obtenerProfesor() async{
  //   final db = await _bd.conectarDB();
  //   final profesores = await db.rawQuery(
  //     '''
  //
  //     ''',[]
  //   );
  // }
}
