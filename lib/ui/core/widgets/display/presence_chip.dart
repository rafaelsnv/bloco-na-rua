// Design system presence chip widget for indicating attendance status.
//
// Renders a colored chip with optional icon for present/absent/pending states.
// Delegates to AppChip base constructor for showIcon=false, or constructs
// with avatar icon for showIcon=true.

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
            color: Colors.white,
          ),
        );
      case PresenceVariant.absent:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.error,
          avatar: Icon(Icons.cancel_rounded, size: 16, color: Colors.white),
        );
      case PresenceVariant.pending:
        return AppChip(
          label: label,
          variant: ChipVariant.filled,
          color: AppColors.warning,
          avatar: Icon(Icons.schedule_rounded, size: 16, color: Colors.white),
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
