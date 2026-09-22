import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_providers.dart';
import 'create_user_page.dart';
import 'user_details_page.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref, {
    required int userId,
    required String userName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Supprimer l’utilisateur'),
          content: Text('Voulez-vous vraiment supprimer $userName ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: FilledButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      final deleteUser = ref.read(deleteUserProvider);

      await deleteUser(userId);

      ref.invalidate(usersProvider);

      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Utilisateur supprimé avec succès')));
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur : $error'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Utilisateurs'),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(usersProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final created = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (context) => const CreateUserPage()),
          );

          if (created == true && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Utilisateur créé avec succès')));
          }
        },
        child: const Icon(Icons.add),
      ),

      body: usersAsync.when(
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
                      ref.invalidate(usersProvider);
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        },
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('Aucun utilisateur trouvé'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(usersProvider);
              await ref.read(usersProvider.future);
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return UserDetailsPage(userId: user.id);
                          },
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?'),
                    ),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\n${user.age} ans'),
                    isThreeLine: true,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('#${user.id}'),
                        IconButton(
                          tooltip: 'Supprimer',
                          onPressed: () {
                            _confirmDelete(context, ref, userId: user.id, userName: user.name);
                          },
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
