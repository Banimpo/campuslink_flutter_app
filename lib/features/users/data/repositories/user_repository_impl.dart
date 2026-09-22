import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_datasource.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<User>> getUsers() async {
    return await remoteDataSource.getUsers();
  }

  @override
  Future<User> createUser({required String name, required int age, required String email}) async {
    return remoteDataSource.createUser(name: name, age: age, email: email);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await remoteDataSource.deleteUser(userId);
  }

  @override
  Future<User> getUserById(int userId) async {
    return remoteDataSource.getUserById(userId);
  }
}
