import 'package:u3_p2_checador_asistencia/models/asistencia.dart';
import 'package:u3_p2_checador_asistencia/models/horario.dart';
import 'package:u3_p2_checador_asistencia/utils/basedatos.dart';

class ControllerHorario {
  final BD _bd = BD();

  Future<int> insertarHorario(Horario h) async {
    final db = await _bd.conectarDB();
    try {
      return await db.transaction((transac) async {
        final idHorario = await transac.insert('HORARIO', h.toJSON());

        Asistencia aTemp = Asistencia(NHORARIO: idHorario);
        final idAsistencia = await transac.insert('ASISTENCIA', aTemp.toJSON());

        if (idHorario == 0 || idAsistencia == 0) {
          //SE DEBE LANZAR UNA EXCEPCION PARA CANCELAR LA TRANSACCIÓN
          throw Exception('Error al insertar horario o asistencia');
        }
        return 1;
      });
    } catch (error) {
      print(error);
      return 0;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHorarios() async {
    final db = await _bd.conectarDB();
    final data = await db.rawQuery('''
    SELECT h.NHORARIO, h.HORA, h.EDIFICIO, h.NMAT, h.SALON, p.NOMBRE, a.ASISTENCIA
    FROM HORARIO h
    INNER JOIN PROFESOR p ON (p.NPROFESOR = h.NPROFESOR)
    INNER JOIN ASISTENCIA a ON (a.NHORARIO = h.NHORARIO) 
    ''', []);
    return data;
  }

  Future<List<Map<String, dynamic>>> filtrarHorario({
    int? asistencia,
    String? nombreProfe,
    String? materia
}
  ) async {
    final db = await _bd.conectarDB();

    String query = ''' 
SELECT h.NHORARIO, h.HORA, h.EDIFICIO, h.NMAT, h.SALON, p.NOMBRE, a.ASISTENCIA
  FROM HORARIO h
  INNER JOIN PROFESOR p ON (p.NPROFESOR = h.NPROFESOR)
  INNER JOIN ASISTENCIA a ON (a.NHORARIO = h.NHORARIO)
  WHERE 1 = 1
''';

    final args = <dynamic>[];

    if(asistencia != null){
      query += ' AND a.ASISTENCIA = ?';
      args.add(asistencia);
    }

    if(nombreProfe != null){
      query += ' AND p.NOMBRE = ?';
      args.add(nombreProfe);
    }

    if(materia != null){
      query += ' AND h.NMAT = ?';
      args.add(materia);
    }
    print("Query: ${query}");

    final data = await db.rawQuery(query,args);

    return data;
  }

  Future<int> modificarAsistencia(
    int NHORARIO,
    String FECHA,
    int ASISTENCIA,
  ) async {
    final db = await _bd.conectarDB();
    return await db.rawUpdate(
      '''
    UPDATE ASISTENCIA SET 
    FECHA = ?,
    ASISTENCIA = ?
    WHERE NHORARIO = ?
    ''',
      [FECHA, ASISTENCIA, NHORARIO],
    );
  }
}
