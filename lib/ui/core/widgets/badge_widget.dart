import 'package:flutter/material.dart';

enum BadgeSize { small, largeSingleDigit, multipleDigits }

class BadgeWidget extends StatelessWidget {
  const BadgeWidget({
    super.key,
    required this.count,
    this.size = BadgeSize.largeSingleDigit,
    this.backgroundColor,
    this.textColor,
  });

  final int count;
  final BadgeSize size;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? Colors.red.shade300;
    final txtColor = textColor ?? Colors.white;

    if (size == BadgeSize.small) {
      return Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
      );
    }

    if (size == BadgeSize.largeSingleDigit) {
      return Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            count > 99 ? '99+' : count.toString(),
            style: TextStyle(
              color: txtColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    // BadgeSize.multipleDigits
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      constraints: const BoxConstraints(minWidth: 20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          count > 99 ? '99+' : count.toString(),
          style: TextStyle(
            color: txtColor,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}