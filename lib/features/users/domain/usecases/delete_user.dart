import '../repositories/user_repository.dart';

class DeleteUser {
  final UserRepository repository;

  DeleteUser(this.repository);

  Future<void> call(int userId) {
    return repository.deleteUser(userId);
  }
}
