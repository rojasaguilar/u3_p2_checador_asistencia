class Profesor {
  String NPROFESOR;
  String NOMBRE;
  String CARRERA;

  Profesor({
    required this.NPROFESOR,
    required this.NOMBRE,
    required this.CARRERA,
  });

  factory Profesor.fromJSON(Map<String, dynamic> json) {
    return Profesor(
      NPROFESOR: json['NPROFESOR'],
      NOMBRE: json['NOMBRE'],
      CARRERA: json['CARRERA'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'NPROFESOR': this.NPROFESOR,
      'NOMBRE': this.NOMBRE,
      'CARRERA': this.CARRERA,
    };
  }
}
