import '../entities/user.dart';

abstract class UserRepository {
  Future<List<User>> getUsers();

  Future<User> createUser({required String name, required int age, required String email});
  Future<void> deleteUser(int userId);
  Future<User> getUserById(int userId);
}
