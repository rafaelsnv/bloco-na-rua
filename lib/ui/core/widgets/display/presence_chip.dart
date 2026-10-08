import "package:flutter/material.dart";

import "../../tokens/app_colors.dart";
import "app_chip.dart";

enum PresenceVariant { present, absent, pending }

class PresenceChip extends StatelessWidget {
  const PresenceChip({
    super.key,
    required this.variant,
    required this.label,
    this.showIcon = true,
  });

  final PresenceVariant variant;
  final String label;
  final bool showIcon;

  factory PresenceChip.present({String? label}) {
    return PresenceChip(
      variant: PresenceVariant.present,
      label: label ?? "Presente",
    );
  }

  factory PresenceChip.absent({String? label}) {
    return PresenceChip(
      variant: PresenceVariant.absent,
      label: label ?? "Ausente",
    );
  }

  factory PresenceChip.pending({String? label}) {
    return PresenceChip(
      variant: PresenceVariant.pending,
      label: label ?? "Pendente",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (showIcon) {
      return _buildWithIcon();
    } else {
      return _buildWithoutIcon();
    }
  }

  /// Foreground for icons on filled chips — matches [AppChip]'s filled
  /// foreground rule: light fills (e.g. warning) get dark text, saturated
  /// fills keep white text, in both brightness modes.
  Color _iconForeground(Color fill) => fill.computeLuminance() > 0.4
      ? AppColors.textPrimary
      : AppColors.textOnPrimary;

  Widget _buildWithIcon() {
    switch (variant) {
      case PresenceVariant.present:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.success,
          avatar: Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: _iconForeground(AppColors.success),
          ),
        );
      case PresenceVariant.absent:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.error,
          avatar: Icon(
            Icons.cancel_rounded,
            size: 16,
            color: _iconForeground(AppColors.error),
          ),
        );
      case PresenceVariant.pending:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.warning,
          avatar: Icon(
            Icons.schedule_rounded,
            size: 16,
            color: _iconForeground(AppColors.warning),
          ),
        );
    }
  }

  Widget _buildWithoutIcon() {
    switch (variant) {
      case PresenceVariant.present:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.success,
        );
      case PresenceVariant.absent:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.error,
        );
      case PresenceVariant.pending:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.warning,
        );
    }
  }
}
