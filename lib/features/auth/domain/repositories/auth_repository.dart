abstract class AuthRepository {
  Future<void> register({
    required String name,
    required int age,
    required String email,
    required String password,
  });

  Future<void> login({required String email, required String password});

  Future<void> logout();
}
