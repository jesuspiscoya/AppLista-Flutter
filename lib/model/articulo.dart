class Articulo {
  final int? codigo;
  late String nombre;
  late double precio;

  Articulo({this.codigo, required this.nombre, required this.precio});

  Articulo.fromMap(Map<String, dynamic> item)
      : codigo = item['cod_art'],
        nombre = item['nombre'],
        precio = item['precio'];

  Map<String, Object?> toMap() {
    return {
      'cod_art': codigo,
      'nombre': nombre,
      'precio': precio,
    };
  }
}
