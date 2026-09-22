import '../entities/user.dart';
import '../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<User> call({required String name, required int age, required String email}) {
    return repository.createUser(name: name, age: age, email: email);
  }
}
