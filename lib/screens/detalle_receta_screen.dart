import 'package:flutter/material.dart';
import 'package:recetas_app/data/opiniones_db.dart';
import 'package:recetas_app/models/opinion.dart';
import 'package:recetas_app/models/receta.dart';

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final _db = OpinionesDb.instancia;
  final _opinionCtrl = TextEditingController();
  List<Opinion> _opiniones = [];

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  @override
  void dispose() {
    _opinionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargar() async {
    final lista = await _db.obtenerPorReceta(widget.receta.id);
    if (mounted) setState(() => _opiniones = lista);
  }

  Future<void> _guardar() async {
    final texto = _opinionCtrl.text.trim();
    if (texto.isEmpty) return;
    await _db.insert(Opinion(recetaId: widget.receta.id, opinion: texto));
    _opinionCtrl.clear();
    await _cargar();
  }

  Future<void> _eliminar(Opinion o) async {
    await _db.eliminar(o.id!);
    await _cargar();
  }

  @override
  Widget build(BuildContext context) {
    final receta = widget.receta;

    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
            (entrada) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.deepOrange,
                    child: Text(
                      '${entrada.key + 1}',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(entrada.value)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Mi Opinión Personal: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _opinionCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Escribe aquí tus notas o comentarios sobre la receta...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _guardar,
            icon: const Icon(Icons.save),
            label: const Text('Guardar Opinión'),
            style: FilledButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 41, 34)),
          ),
          ..._opiniones.map(
            (o) => ListTile(
              title: Text(o.opinion),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _eliminar(o),
              ),
            ),
          ),
        ],
      ),
    );
  }
}