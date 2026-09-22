import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_providers.dart';

class UserDetailsPage extends ConsumerWidget {
  final int userId;

  const UserDetailsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l’utilisateur'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(userDetailsProvider(userId));
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: userAsync.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Erreur : $error', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ref.invalidate(userDetailsProvider(userId));
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (user) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              CircleAvatar(
                radius: 50,
                child: Text(
                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 36),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.numbers),
                      title: const Text('Identifiant'),
                      subtitle: Text('${user.id}'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Nom'),
                      subtitle: Text(user.name),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.cake),
                      title: const Text('Âge'),
                      subtitle: Text('${user.age} ans'),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Adresse e-mail'),
                      subtitle: Text(user.email),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
