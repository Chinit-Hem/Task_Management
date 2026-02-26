import 'package:flutter/material.dart';
import '../../domain/models/task_model.dart';

/// PriorityChip - A reusable widget for displaying task priority
///
/// Shows a colored pill/chip indicating the priority level:
/// - Low: Yellow/Orange border with light background
/// - Medium: Orange fill with white text
/// - High: Red fill with white text
class PriorityChip extends StatelessWidget {
  final Priority priority;
  final bool showLabel;
  final bool isOutlined;
  final bool compact;
  final VoidCallback? onTap;

  const PriorityChip({
    super.key,
    required this.priority,
    this.showLabel = true,
    this.isOutlined = false,
    this.compact = false,
    this.onTap,
  });

  /// Get color based on priority
  Color get _priorityColor {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFF44336); // Red
      case Priority.medium:
        return const Color(0xFFFF9800); // Orange
      case Priority.low:
        return const Color(0xFFFFC107); // Yellow
    }
  }

  /// Get background color (lighter version)
  Color get _backgroundColor {
    switch (priority) {
      case Priority.high:
        return const Color(0xFFFFEBEE); // Light red
      case Priority.medium:
        return const Color(0xFFFFF3E0); // Light orange
      case Priority.low:
        return const Color(0xFFFFFDE7); // Light yellow
    }
  }

  /// Get priority label text
  String get _label {
    switch (priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor;
    final bgColor = _backgroundColor;

    Widget chip;

    if (isOutlined) {
      // Outlined style (for low priority or when explicitly requested)
      chip = Container(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: color, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                _label,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    } else {
      // Filled style (for medium/high priority)
      chip = Container(
        padding: compact
            ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: 6),
              Text(
                _label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    return chip;
  }
}

/// PrioritySelector - Interactive widget for selecting priority
///
/// Shows 3 buttons (Low/Medium/High) with the selected one highlighted
class PrioritySelector extends StatelessWidget {
  final Priority selectedPriority;
  final ValueChanged<Priority> onPriorityChanged;

  const PrioritySelector({
    super.key,
    required this.selectedPriority,
    required this.onPriorityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildPriorityButton(Priority.low, 'Low', const Color(0xFFFFC107)),
        const SizedBox(width: 12),
        _buildPriorityButton(
            Priority.medium, 'Medium', const Color(0xFFFF9800)),
        const SizedBox(width: 12),
        _buildPriorityButton(Priority.high, 'High', const Color(0xFFF44336)),
      ],
    );
  }

  Widget _buildPriorityButton(Priority priority, String label, Color color) {
    final isSelected = selectedPriority == priority;

    return Expanded(
      child: GestureDetector(
        onTap: () => onPriorityChanged(priority),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.transparent,
            border: Border.all(
              color: color,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : color,
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
