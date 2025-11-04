class Horario {
  int? NHORARIO;
  String NPROFESOR;
  String NMAT;
  String HORA;
  String EDIFICIO;
  String SALON;

  Horario({
    this.NHORARIO,
    required this.NPROFESOR,
    required this.NMAT,
    required this.HORA,
    required this.EDIFICIO,
    required this.SALON,
  });

  factory Horario.fromJSON(Map<String, dynamic> json) {
    return Horario(
      NHORARIO: json['NHORARIO'],
      NPROFESOR: json['NPROFESOR'],
      NMAT: json['NMAT'],
      HORA: json['HORA'],
      EDIFICIO: json['EDIFICIO'],
      SALON: json['SALON'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'NHORARIO': this.NHORARIO,
      'NPROFESOR': this.NPROFESOR,
      'NMAT': this.NMAT,
      'HORA': this.HORA,
      'EDIFICIO': this.EDIFICIO,
      'SALON': this.SALON,
    };
  }
}
