class Asistencia {
  int? IDASISTENCIA;
  int NHORARIO;
  String? FECHA;
  bool? ASISTENCIA;

  Asistencia({
    this.IDASISTENCIA,
    required this.NHORARIO,
    this.FECHA,
    this.ASISTENCIA,
  });

  factory Asistencia.fromJSON(Map<String, dynamic> json) {
    return Asistencia(
      NHORARIO: json['NHORARIO'],
      FECHA: json['FECHA'],
      ASISTENCIA: json['ASISTENCIA'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'IDASISTENCIA': this.IDASISTENCIA,
      'NHORARIO': this.NHORARIO,
      'FECHA': this.FECHA,
      'ASISTENCIA': this.ASISTENCIA,
    };
  }
}
