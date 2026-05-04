import 'package:flutter/material.dart';

/// Tipos de erro para exibir mensagens contextualizadas
enum ApiErrorType {
  network,
  timeout,
  server,
  auth,
  unknown,
}

class ErrorStateWidget extends StatelessWidget {
  const ErrorStateWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.errorType,
    this.title,
  });

  final String message;
  final VoidCallback? onRetry;
  final ApiErrorType? errorType;
  final String? title;

  IconData get _icon => _getIcon(errorType);
  String get _defaultTitle => 'Ops! Algo deu errado';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.8 + (0.2 * value),
                    child: child,
                  ),
                );
              },
              child: Icon(
                _icon,
                size: 80,
                color: Colors.red.shade300,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title ?? _defaultTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade500,
                  ),
              textAlign: TextAlign.center,
            ),
            if (_getSubtitle(errorType) != null) ...[
              const SizedBox(height: 4),
              Text(
                _getSubtitle(errorType)!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade400,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tentar novamente'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon(ApiErrorType? type) {
    switch (type) {
      case ApiErrorType.network:
        return Icons.wifi_off;
      case ApiErrorType.timeout:
        return Icons.timer_off;
      case ApiErrorType.server:
        return Icons.cloud_off;
      case ApiErrorType.auth:
        return Icons.lock_outline;
      case ApiErrorType.unknown:
      case null:
        return Icons.error_outline;
    }
  }

  String? _getSubtitle(ApiErrorType? type) {
    switch (type) {
      case ApiErrorType.network:
        return 'Verifique sua conexão Wi-Fi';
      case ApiErrorType.timeout:
        return 'Tente novamente em alguns minutos';
      case ApiErrorType.server:
        return 'O servidor está indisponível no momento';
      case ApiErrorType.auth:
        return 'Faça login novamente para continuar';
      case ApiErrorType.unknown:
      case null:
        return null;
    }
  }
}