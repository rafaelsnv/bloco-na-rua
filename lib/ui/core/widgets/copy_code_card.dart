import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../colors/app_colors.dart';

class CopyCodeCard extends StatefulWidget {
  const CopyCodeCard({
    super.key,
    required this.code,
    this.label,
    this.isManager = false,
  });

  final String code;
  final String? label;
  final bool isManager;

  @override
  State<CopyCodeCard> createState() => _CopyCodeCardState();
}

class _CopyCodeCardState extends State<CopyCodeCard> {
  bool _isCodeVisible = false;

  Future<void> _copyToClipboard(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Código ${widget.isManager ? "gerente" : ""} copiado!'),
            ],
          ),
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => _copyToClipboard(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isManager
                      ? AppColors.admin.withValues(alpha: 0.15)
                      : AppColors.info.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isManager ? Icons.admin_panel_settings : Icons.vpn_key,
                  color: widget.isManager ? AppColors.admin : AppColors.info,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label ?? 'Código de convite',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isCodeVisible ? widget.code : '••••••••',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: _isCodeVisible ? 1.5 : 2.0,
                          ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  _isCodeVisible ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).colorScheme.outline,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isCodeVisible = !_isCodeVisible;
                  });
                },
              ),
              Icon(
                Icons.copy,
                color: Theme.of(context).colorScheme.outline,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
