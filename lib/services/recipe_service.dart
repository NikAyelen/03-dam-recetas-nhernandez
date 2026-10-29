import 'dart:convert';

import 'package:recetas_app/models/receta.dart';
import 'package:http/http.dart' as http;

class RecipeService {
  static const String _baseUrl = "https://dummyjson.com/recipes";

  Future<List<Receta>> obtenerRecetas() async {
    final Uri url = Uri.parse(_baseUrl);
    final http.Response respuesta = await http.get(url);
    // evaluamos la respuesta
    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> datos = jsonDecode(respuesta.body);
      final List<dynamic> listaRecetas = datos['recipes'];
      print(listaRecetas);
      return listaRecetas
          .map((recetaJson) => Receta.fromJson(recetaJson))
          .toList();
    } else {
      throw Exception("error al obtener las recetas: ${respuesta.statusCode}");
    }
  }
}