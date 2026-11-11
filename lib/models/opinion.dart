class Opinion {
  final int? id;
  final int recetaId; // id de la receta (viene de dummyjson)
  final String opinion;

  const Opinion({this.id, required this.recetaId, required this.opinion});

  // objeto -> map (para guardar en sqlite)
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'receta_id': recetaId,
      'opinion': opinion,
    };
  }

  factory Opinion.fromMap(Map<String, Object?> mapa) {
    return Opinion(
      id: mapa['id'] as int?,
      recetaId: mapa['receta_id'] as int,
      opinion: mapa['opinion'] as String,
    );
  }
}