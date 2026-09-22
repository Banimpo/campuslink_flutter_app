import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../data/datasources/user_remote_datasource.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users.dart';
import '../../domain/usecases/create_user.dart';
import '../../domain/usecases/delete_user.dart';
import '../../domain/usecases/get_user_by_id.dart';

final httpClientProvider = Provider<http.Client>((ref) {
  final client = http.Client();

  ref.onDispose(client.close);

  return client;
});

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(client: ref.watch(httpClientProvider));
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(remoteDataSource: ref.watch(userRemoteDataSourceProvider));
});

final getUsersProvider = Provider<GetUsers>((ref) {
  return GetUsers(ref.watch(userRepositoryProvider));
});

final usersProvider = FutureProvider<List<User>>((ref) async {
  final getUsers = ref.watch(getUsersProvider);

  return getUsers();
});

final createUserProvider = Provider<CreateUser>((ref) {
  return CreateUser(ref.watch(userRepositoryProvider));
});

final deleteUserProvider = Provider<DeleteUser>((ref) {
  return DeleteUser(ref.watch(userRepositoryProvider));
});

final getUserByIdProvider = Provider<GetUserById>((ref) {
  return GetUserById(ref.watch(userRepositoryProvider));
});

final userDetailsProvider = FutureProvider.family<User, int>((ref, userId) async {
  final getUserById = ref.watch(getUserByIdProvider);
  return getUserById(userId);
});
