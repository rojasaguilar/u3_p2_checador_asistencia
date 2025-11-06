import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class BD {
  Future<Database> conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), 'checador1_3.db'),
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        //TABLA PROFESOR
        await db.execute(
          'CREATE TABLE PROFESOR'
          '(NPROFESOR TEXT PRIMARY KEY,'
          ' NOMBRE TEXT,'
          ' CARRERA TEXT)',
        );

        await db.execute(
          'CREATE TABLE MATERIA'
          '(NMAT TEXT PRIMARY KEY,'
          ' DESCRIPCION TEXT)',
        );

        await db.execute(
          'CREATE TABLE HORARIO'
          '(NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' NPROFESOR TEXT,'
          ' NMAT TEXT,'
          ' HORA TEXT,'
          ' EDIFICIO TEXT,'
          ' SALON TEXT,'
          ' FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR(NPROFESOR),'
          ' FOREIGN KEY (NMAT) REFERENCES MATERIA(NMAT)'
          ' ON DELETE CASCADE ON UPDATE CASCADE)',
        );

        await db.execute(
          'CREATE TABLE ASISTENCIA'
          '(IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT,'
          ' NHORARIO INT,'
          ' FECHA TEXT,'
          ' ASISTENCIA INTEGER,'
          ' FOREIGN KEY (NHORARIO) REFERENCES HORARIO(NHORARIO)'
          ' ON DELETE CASCADE ON UPDATE CASCADE)',
        );
      },
    );
  }
}
