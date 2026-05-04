import 'package:flutter/material.dart';

/// Widget que exibe um card especial quando o servidor está fora do ar (503/5xx).
///
/// Usar quando:
/// - Status code 503
/// - Status code 500, 502, 504
/// - Qualquer erro 5xx
class ServerErrorCard extends StatelessWidget {
  const ServerErrorCard({
    super.key,
    this.customMessage,
    this.onRetry,
    this.showAnimation = false,
  });

  /// Mensagem customizada (opcional, usa padrão se null)
  final String? customMessage;

  /// Callback de retry
  final VoidCallback? onRetry;

  /// Se verdadeiro, mostra ícone animado de "nuvem com raio"
  final bool showAnimation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.grey.shade700,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                showAnimation ? Icons.cloud_off : Icons.cloud_off,
                size: 64,
                color: Colors.white70,
              ),
              const SizedBox(height: 16),
              Text(
                'Ops! Servidor indisponível',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                customMessage ??
                    'O servidor está temporariamente fora do ar.\n'
                        'Isso geralmente acontece quando há muitas\n'
                        'requisições ou manutenção programada.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                    ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: onRetry,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white70),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: const Text('Tentar novamente'),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                'Se o problema persistir, entre em contato com suporte.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
