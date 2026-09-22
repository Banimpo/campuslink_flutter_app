import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<void> register({
    required String name,
    required int age,
    required String email,
    required String password,
  }) async {
    final token = await remoteDataSource.register(
      name: name,
      age: age,
      email: email,
      password: password,
    );

    await localDataSource.saveToken(token);
  }

  @override
  Future<void> login({required String email, required String password}) async {
    final token = await remoteDataSource.login(email: email, password: password);

    await localDataSource.saveToken(token);
  }

  @override
  Future<void> logout() {
    return localDataSource.deleteToken();
  }
}
