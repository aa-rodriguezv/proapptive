class HttpCustomException implements Exception {
  final String message;

  HttpCustomException(this.message);

  @override
  String toString() {
    return 'Cuando se intentó autenticar esta fue la respuesta del servidor:$message';
  }
}
