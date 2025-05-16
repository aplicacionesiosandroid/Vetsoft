class CartItemAdd {
  int producto_id;
  String producto_nombre;
  int cantidad;
  dynamic precio_unitario;
  double monto;
  String imagen;

  CartItemAdd(
      {required this.producto_id,
      required this.producto_nombre,
      required this.cantidad,
      required this.precio_unitario,
      required this.monto,
      required this.imagen});
}
