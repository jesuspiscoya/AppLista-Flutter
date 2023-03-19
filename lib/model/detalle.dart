class Detalle {
  final int? codigo;
  late int? codLista;
  late int codArticulo;
  late String unidad;
  late int cantidad;

  Detalle({
    this.codigo,
    this.codLista,
    required this.codArticulo,
    required this.unidad,
    required this.cantidad,
  });

  Detalle.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_deta_list'],
        codLista = item['cod_list'],
        codArticulo = item['cod_art'],
        unidad = item['unidad'],
        cantidad = item['cantidad'];

  Map<String, Object?> toMap() {
    return {
      'cod_deta_list': codigo,
      'cod_list': codLista,
      'cod_art': codArticulo,
      'unidad': unidad,
      'cantidad': cantidad,
    };
  }
}
