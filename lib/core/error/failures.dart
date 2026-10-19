abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error try again later']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Check your internet connection and Try again',
  ]);
}
