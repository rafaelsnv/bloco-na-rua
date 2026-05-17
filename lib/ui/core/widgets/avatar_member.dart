import 'package:flutter/material.dart';

import '../colors/app_colors.dart';

class AvatarMember extends StatelessWidget {
  const AvatarMember({
    super.key,
    required this.memberId,
    this.name,
    this.role,
    this.size = 40,
  });

  final int memberId;
  final String? name;
  final String? role;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role?.toLowerCase() == 'admin' || role?.toLowerCase() == 'gerente';
    final colorScheme = Theme.of(context).colorScheme;

    // Use name initial if available, otherwise memberId
    final displayText = name != null && name!.isNotEmpty
        ? name![0].toUpperCase()
        : memberId.toString();

    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: isAdmin
              ? AppColors.admin.withValues(alpha: 0.2)
              : colorScheme.secondaryContainer,
          child: Text(
            displayText,
            style: TextStyle(
              color: isAdmin ? AppColors.admin : colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.bold,
              fontSize: size * 0.4,
            ),
          ),
        ),
        if (isAdmin)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppColors.admin,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Icon(
                Icons.star,
                size: size * 0.25,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
