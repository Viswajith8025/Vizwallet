sealed class AppFailure implements Exception {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure([super.message = 'Database operation failed']);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Record not found']);
}

final class BackupFailure extends AppFailure {
  const BackupFailure([super.message = 'Backup operation failed']);
}
