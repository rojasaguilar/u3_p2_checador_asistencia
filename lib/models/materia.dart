class Materia {
  String NMAT;
  String DESCRIPCION;

  Materia({required this.NMAT, required this.DESCRIPCION});

  factory Materia.fromJSON(Map<String, dynamic> json) {
    return Materia(NMAT: json['NMAT'], DESCRIPCION: json['DESCRIPCION']);
  }

  Map<String, dynamic> toJSON() {
    return {'NMAT': this.NMAT, 'DESCRIPCION': this.DESCRIPCION};
  }
}
