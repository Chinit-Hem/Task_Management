// Checkbox Widget - Flutter equivalent of React Native Checkbox.tsx
// Custom styled checkbox with animation

import 'package:flutter/material.dart';

class CheckboxWidget extends StatelessWidget {
  final bool checked;
  final VoidCallback onToggle;

  const CheckboxWidget({
    super.key,
    required this.checked,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: checked ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: checked ? Colors.deepPurple : Colors.grey[400]!,
            width: 2,
          ),
        ),
        child: checked
            ? const Icon(
                Icons.check,
                size: 16,
                color: Colors.white,
              )
            : null,
      ),
    );
  }
}
