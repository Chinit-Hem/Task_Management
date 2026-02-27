import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/task_model.dart';

/// TaskCard - Figma-matched design
/// Layout: [left border] [checkbox] [content: category+priority+title+time] [image thumbnail right]
class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onToggle;
  final VoidCallback? onTap;
  final bool showImage;

  const TaskCard({
    super.key,
    required this.task,
    this.onToggle,
    this.onTap,
    this.showImage = true,
  });

  Color get _priorityColor {
    switch (task.priority) {
      case Priority.high:
        return const Color(0xFFF44336); // Red
      case Priority.medium:
        return const Color(0xFFFF9800); // Orange
      case Priority.low:
        return const Color(0xFF4CAF50); // Green
    }
  }

  String get _priorityLabel {
    switch (task.priority) {
      case Priority.high:
        return 'HIGH PRIORITY';
      case Priority.medium:
        return 'MEDIUM PRIORITY';
      case Priority.low:
        return 'LOW PRIORITY';
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage =
        showImage && task.imagePath != null && task.imagePath!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: _priorityColor, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap ??
              () => context.push('/task-detail/${task.id}', extra: task),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Checkbox - 48x48 tap area
                GestureDetector(
                  onTap: onToggle,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: task.isCompleted
                              ? _priorityColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: task.isCompleted
                                ? _priorityColor
                                : Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge + Priority badge row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              task.category,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _priorityColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _priorityLabel,
                              style: TextStyle(
                                fontSize: 10,
                                color: _priorityColor,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Task title
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? Colors.grey.shade500
                              : AppColors.textPrimary,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Due date/time
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 13, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _buildDueText(),
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey.shade500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Image thumbnail (right side)
                if (hasImage) ...[
                  const SizedBox(width: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildImage(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _buildDueText() {
    final date = task.formattedDueDate;
    final time = task.formattedDueTime;
    if (date.isEmpty && time.isEmpty) return 'No due date';
    if (time.isEmpty) return 'Due $date';
    if (date.isEmpty) return time;
    return 'Due $date, $time';
  }

  Widget _buildImage() {
    final imagePath = task.imagePath;
    if (imagePath == null || imagePath.isEmpty) return const SizedBox.shrink();

    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
      );
    } else {
      return Image.file(
        File(imagePath),
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 64,
      height: 64,
      color: Colors.grey.shade200,
      child: Icon(Icons.image_not_supported_outlined,
          color: Colors.grey.shade400, size: 24),
    );
  }
}

/// TaskCardSkeleton - Loading placeholder matching Figma card layout
class TaskCardSkeleton extends StatelessWidget {
  const TaskCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            const Border(left: BorderSide(color: Color(0xFFE0E0E0), width: 4)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(5)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                          width: 60,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6))),
                      const SizedBox(width: 8),
                      Container(
                          width: 90,
                          height: 18,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                      width: double.infinity,
                      height: 15,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4))),
                  const SizedBox(height: 6),
                  Container(
                      width: 100,
                      height: 12,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4))),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10))),
          ],
        ),
      ),
    );
  }
}
