class Lista {
  final int? codigo;
  final String titulo;
  final int cantidad;
  final double total;
  final int estado;

  Lista(
      {this.codigo,
      required this.titulo,
      required this.cantidad,
      required this.total,
      required this.estado});

  Lista.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_list'],
        titulo = item['titulo'],
        cantidad = item['cantidad'],
        total = item['total'],
        estado = item['estado'];

  Map<String, Object?> toMap() {
    return {
      'cod_list': codigo,
      'titulo': titulo,
      'cantidad': cantidad,
      'total': total,
      'estado': estado,
    };
  }
}
