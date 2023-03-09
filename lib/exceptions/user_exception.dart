class UserException implements Exception {
  final String message;
  UserException(this.message);
  String errorMessage() {
    return "Errore personalizzato: $message";
  }
}
