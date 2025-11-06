import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:u3_p2_checador_asistencia/components/horarioCard.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerHorario.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerMateria.dart';
import 'package:u3_p2_checador_asistencia/controllers/controllerProfesor.dart';
import 'package:u3_p2_checador_asistencia/pages/addHorario.dart';

class Horarios extends StatefulWidget {
  const Horarios({super.key});

  @override
  State<Horarios> createState() => _HorariosState();
}

class _HorariosState extends State<Horarios> {
  List<Map<String, dynamic>> horarios = [];

  List<String> materias = [];
  List<String> profesores = [];

  int? asistencia;
  String? profesor;
  String? materia;

  final controllerHorario = ControllerHorario();
  final controllerProfesor = ControllerProfesor();
  final controllerMateria = ControllerMateria();

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    await Future.wait([
      _obtenerProfesores(),
      _obtenerMaterias(),
      actualizarHorarios(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilledButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Addhorario(onAdd: actualizarHorarios),
                ),
              );
            },
            child: const Text("Agregar Horarios"),
          ),

          const SizedBox(height: 10),

          /// ---- FILTROS ----
          _buildFiltros(),

          const SizedBox(height: 10),

          Text("Horarios (${horarios.length})"),

          const SizedBox(height: 10),

          /// ---- LISTA ----
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: horarios
                  .map(
                    (horario) => Horariocard(
                      horario: horario,
                      onUpdate: actualizarHorarios,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  //  FILTROS REUTILIZABLES
  Widget _buildFiltros() {
    return Column(
      children: [
        Row(
          children: [
            _dropdownAsistencia(),
            const SizedBox(width: 20),
            _dropdownTexto(
              label: "Profesor",
              value: profesor,
              lista: profesores,
              onChange: (v) => profesor = v,
            ),
          ],
        ),
        Row(
          children: [
            _dropdownTexto(
              label: "Materia",
              value: materia,
              lista: materias,
              onChange: (v) => materia = v,
            ),
            const SizedBox(width: 20),
            IconButton(
              onPressed: () {
                setState(() {
                  asistencia = null;
                  profesor = null;
                  materia = null;
                });
                actualizarHorarios();
              },
              icon: const Icon(CupertinoIcons.xmark, size: 16),
            ),
          ],
        ),
      ],
    );
  }

  // Dropdown: Asistencia/Falta
  Widget _dropdownAsistencia() {
    return DropdownButton<int>(
      hint: const Text("Asistencia/Falta", style: TextStyle(fontSize: 12)),
      value: asistencia,
      items: const [
        DropdownMenuItem(
          value: 1,
          child: Text("ASISTENCIA", style: TextStyle(fontSize: 11)),
        ),
        DropdownMenuItem(
          value: 0,
          child: Text("FALTA", style: TextStyle(fontSize: 11)),
        ),
      ],
      onChanged: (v) {
        setState(() => asistencia = v);
        _filtrar();
      },
    );
  }

  // Dropdown general para texto
  Widget _dropdownTexto({
    required String label,
    required String? value,
    required List<String> lista,
    required Function(String?) onChange,
  }) {
    return DropdownButton<String>(
      hint: Text(label, style: const TextStyle(fontSize: 12)),
      value: value,
      items: lista
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 11)),
            ),
          )
          .toList(),
      onChanged: (v) {
        setState(() => onChange(v));
        _filtrar();
      },
    );
  }

  Future<void> actualizarHorarios() async {
    final data = await controllerHorario.obtenerHorarios();
    setState(() => horarios = data);
  }

  Future<void> _obtenerProfesores() async {
    final data = await controllerProfesor.obtenerProfesores();
    profesores = data.map((p) => p.NOMBRE).toList();
    setState(() {});
  }

  Future<void> _obtenerMaterias() async {
    final data = await controllerMateria.obtenerMaterias();
    materias = data.map((m) => m.NMAT).toList();
    setState(() {});
  }

  Future<void> _filtrar() async {
    final data = await controllerHorario.filtrarHorario(
      asistencia: asistencia,
      nombreProfe: profesor,
      materia: materia,
    );
    setState(() => horarios = data);
  }
}
