import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../features/task_management/application/providers/task_providers.dart';
import '../../features/task_management/domain/models/task_model.dart';
import '../../widgets/delete_confirmation_modal.dart';

class TaskDetailScreen extends ConsumerWidget {
  final TaskModel task;

  const TaskDetailScreen({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskByIdProvider(task.id));

    return taskAsync.when(
      data: (updatedTask) {
        final displayTask = updatedTask ?? task;
        return _buildContent(context, ref, displayTask);
      },
      loading: () => _buildContent(context, ref, task),
      error: (_, __) => _buildContent(context, ref, task),
    );
  }

  Widget _buildContent(
      BuildContext context, WidgetRef ref, TaskModel displayTask) {
    final priorityColor = displayTask.priority == Priority.high
        ? const Color(0xFFF44336)
        : displayTask.priority == Priority.medium
            ? const Color(0xFFFF9800)
            : const Color(0xFF4CAF50);

    final priorityLabel = displayTask.priority == Priority.high
        ? 'High Priority'
        : displayTask.priority == Priority.medium
            ? 'Medium Priority'
            : 'Low Priority';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'TASK DETAILS',
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: AppColors.textPrimary),
            onSelected: (value) {
              if (value == 'edit') {
                context.push('/edit-task/${displayTask.id}',
                    extra: displayTask);
              } else if (value == 'delete') {
                _confirmDelete(context, ref, displayTask);
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(children: [
                  const Icon(Icons.edit_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text('Edit Task', style: GoogleFonts.poppins(fontSize: 14)),
                ]),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(children: [
                  const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  const SizedBox(width: 8),
                  Text('Delete Task',
                      style:
                          GoogleFonts.poppins(fontSize: 14, color: Colors.red)),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: displayTask.isCompleted
                    ? const Color(0xFF4CAF50).withOpacity(0.12)
                    : AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                displayTask.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: displayTask.isCompleted
                      ? const Color(0xFF4CAF50)
                      : AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              displayTask.title,
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                decoration:
                    displayTask.isCompleted ? TextDecoration.lineThrough : null,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            if (displayTask.imagePath != null &&
                displayTask.imagePath!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.file(
                  File(displayTask.imagePath!),
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey.shade200,
                    child: Icon(Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400, size: 48),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    label: 'DEADLINES',
                    value: displayTask.dueDate != null
                        ? DateFormat('MMMM d, yyyy')
                            .format(displayTask.dueDate!)
                        : 'No deadline',
                    icon: Icons.calendar_today_outlined,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInfoTile(
                    label: 'PRIORITIES',
                    value: priorityLabel,
                    icon: Icons.flag_outlined,
                    iconColor: priorityColor,
                    valueColor: priorityColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (displayTask.dueDate != null)
              _buildInfoTile(
                label: 'SCHEDULE',
                value: DateFormat('h:mm a').format(displayTask.dueDate!),
                icon: Icons.access_time_rounded,
                iconColor: AppColors.primary,
              ),
            const SizedBox(height: 20),
            if (displayTask.description != null &&
                displayTask.description!.isNotEmpty) ...[
              Text('DESCRIPTION',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Text(
                  displayTask.description!,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.6),
                ),
              ),
              const SizedBox(height: 20),
            ],
            if (displayTask.subtasks.isNotEmpty) ...[
              Text('SUBTASKS',
                  style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.8)),
              const SizedBox(height: 8),
              ...displayTask.subtasks.map((subtask) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        Icon(
                          displayTask.isCompleted
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: displayTask.isCompleted
                              ? const Color(0xFF4CAF50)
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            subtask,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: displayTask.isCompleted
                                  ? Colors.grey.shade500
                                  : AppColors.textPrimary,
                              decoration: displayTask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 20),
            ],
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -4))
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () => _toggleTaskCompletion(context, ref, displayTask),
              icon: Icon(
                  displayTask.isCompleted
                      ? Icons.refresh_rounded
                      : Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20),
              label: Text(
                displayTask.isCompleted
                    ? 'Mark as Pending'
                    : 'Mark as Complete',
                style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.6)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ?? AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTaskCompletion(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
  ) async {
    final success = await ref
        .read(taskNotifierProvider.notifier)
        .toggleTaskCompletion(task.id);

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            task.isCompleted ? 'Task marked as pending' : 'Task completed!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    TaskModel task,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DeleteConfirmationModal(
        title: 'Delete Task?',
        message:
            'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
        confirmText: 'Delete',
        onConfirm: () {},
      ),
    );

    if (confirmed == true && context.mounted) {
      final success =
          await ref.read(taskNotifierProvider.notifier).deleteTask(task.id);

      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Task deleted successfully',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    }
  }
}
