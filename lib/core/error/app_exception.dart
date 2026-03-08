/// Exceptions métier remontées depuis l'API ou le réseau.
class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? code;

  const AppException({
    required this.message,
    this.statusCode,
    this.code,
  });

  @override
  String toString() => 'AppException($statusCode): $message';
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'Pas de connexion internet', super.code = 'NETWORK_ERROR'});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Session expirée, reconnectez-vous', super.statusCode = 401});
}

class ServerException extends AppException {
  const ServerException({super.message = 'Erreur serveur, réessayez plus tard', super.statusCode = 500});
}

class ValidationException extends AppException {
  final Map<String, List<String>> errors;
  const ValidationException({required this.errors, super.message = 'Données invalides', super.statusCode = 422});
}

class NotFoundException extends AppException {
  const NotFoundException({super.message = 'Ressource introuvable', super.statusCode = 404});
}
