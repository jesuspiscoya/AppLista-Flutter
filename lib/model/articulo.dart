class Articulo {
  final int? codigo;
  final String nombre;
  final double precio;
  final int cantidad;
  final String unidad;

  Articulo(
      {this.codigo,
      required this.nombre,
      required this.precio,
      required this.cantidad,
      required this.unidad});

  Articulo.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_art'],
        nombre = item['nombre'],
        precio = item['precio'],
        cantidad = item['cantidad'],
        unidad = item['unidad'];

  Map<String, Object?> toMap() {
    return {
      'cod_art': codigo,
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'unidad': unidad,
    };
  }
}
