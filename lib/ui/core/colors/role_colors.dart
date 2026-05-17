import 'package:bloco_na_rua/ui/core/colors/app_colors.dart';
import 'package:flutter/material.dart';

extension RoleColors on BuildContext {
  Color getRoleColor(String? role) {
    switch (role) {
      case 'admin':
      case 'gerente':
        return AppColors.admin;
      case 'member':
      default:
        return AppColors.primary;
    }
  }

  Color getPresenceColor(String presence) {
    switch (presence) {
      case 'present':
        return AppColors.success;
      case 'absent':
        return AppColors.error;
      case 'late':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }
}
