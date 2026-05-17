import 'package:bloco_na_rua/ui/auth/cubit/auth_cubit.dart';
import 'package:bloco_na_rua/ui/auth/cubit/auth_state.dart';
import 'package:bloco_na_rua/ui/core/widgets/error_state_widget.dart';
import 'package:bloco_na_rua/ui/profile/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
          ),
          body: state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (message) => ErrorStateWidget(
              message: message,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            ),
            loaded: (member) => _buildProfileContent(
              context,
              member.name ?? '',
              member.email ?? '',
              member.phone ?? '',
              member.createdAt,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    String name,
    String email,
    String phone,
    DateTime? createdAt,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            email,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),

          const SizedBox(height: 32),

          // Info Cards
          _buildInfoCard(
            context,
            icon: Icons.phone,
            title: 'Telefone',
            value: phone.isNotEmpty ? phone : 'Não informado',
          ),
          const SizedBox(height: 12),
          _buildInfoCard(
            context,
            icon: Icons.calendar_today,
            title: 'Membro desde',
            value: createdAt != null
                ? DateFormat('MMMM/yyyy', 'pt_BR').format(createdAt)
                : 'Não disponível',
          ),

          const SizedBox(height: 32),

          // Edit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TO-DO: Implement edit profile
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Editar perfil - Em breve!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text('Editar Perfil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: BlocListener<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthUnauthenticated) {
                  context.go('/login');
                } else if (state is AuthFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  );
                }
              },
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text('Sair', style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthCubit>().logout();
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
