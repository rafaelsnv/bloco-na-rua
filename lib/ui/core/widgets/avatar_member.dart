import 'package:flutter/material.dart';

class AvatarMember extends StatelessWidget {
  const AvatarMember({
    super.key,
    required this.memberId,
    this.role,
    this.size = 40,
  });

  final int memberId;
  final String? role;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role?.toLowerCase() == 'admin' || role?.toLowerCase() == 'gerente';

    return Stack(
      children: [
        CircleAvatar(
          radius: size / 2,
          backgroundColor: isAdmin
              ? Colors.amber.shade100
              : Colors.purpleAccent.shade100,
          child: Text(
            memberId.toString(),
            style: TextStyle(
              color: isAdmin ? Colors.amber.shade700 : Colors.purple.shade700,
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
                color: Colors.amber.shade600,
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
