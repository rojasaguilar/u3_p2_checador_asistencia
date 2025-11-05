import 'dart:math';

class Profesor {
  String NPROFESOR;
  String NOMBRE;
  String CARRERA;

  Profesor({required this.NOMBRE, required this.CARRERA})
    : NPROFESOR = _generarProfesorId(NOMBRE, CARRERA);

  Profesor._fromDB(this.NPROFESOR, this.NOMBRE, this.CARRERA);

  factory Profesor.fromJSON(Map<String, dynamic> json) {
    return Profesor._fromDB(json['NPROFESOR'], json['NOMBRE'], json['CARRERA']);
  }

  Map<String, dynamic> toJSON() {
    return {
      'NPROFESOR': this.NPROFESOR,
      'NOMBRE': this.NOMBRE,
      'CARRERA': this.CARRERA,
    };
  }

  static String _generarProfesorId(String nombre, String carrera) {
    final random = Random();
    final numero = random.nextInt(9000) + 1000;
    return "${nombre.replaceAll(' ', '')}${carrera}${numero}";
  }
}
