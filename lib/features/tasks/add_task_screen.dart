import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/constants/app_constants.dart';
import '../../features/task_management/application/providers/task_providers.dart';
import '../../features/task_management/domain/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? taskToEdit;
  final DateTime? preselectedDate;

  const AddTaskScreen({
    super.key,
    this.taskToEdit,
    this.preselectedDate,
  });

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _subtaskController = TextEditingController();

  Priority _selectedPriority = Priority.medium;
  String _selectedCategory = 'Personal';
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  String? _imagePath;
  final List<String> _subtasks = [];

  bool get _isEditing => widget.taskToEdit != null;

  final List<String> _categories = ['Work', 'Personal', 'Urgent', 'School'];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _prefillForm();
    } else if (widget.preselectedDate != null) {
      _dueDate = widget.preselectedDate;
    }
  }

  void _prefillForm() {
    final task = widget.taskToEdit!;
    _titleController.text = task.title;
    _descriptionController.text = task.description ?? '';
    _selectedPriority = task.priority;
    _selectedCategory = task.category;
    _dueDate = task.dueDate;
    if (task.dueDate != null) {
      _dueTime = TimeOfDay.fromDateTime(task.dueDate!);
    }
    _imagePath = task.imagePath;
    _subtasks.addAll(task.subtasks);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subtaskController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'Select Time';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatSchedule() {
    if (_dueDate == null && _dueTime == null) return 'Set date & time';
    final datePart = _dueDate != null
        ? DateFormat('MMM d, yyyy').format(_dueDate!)
        : 'Today';
    final timePart = _dueTime != null ? _formatTime(_dueTime) : '';
    return timePart.isNotEmpty ? '$datePart, $timePart' : datePart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: TextButton(
          onPressed: () => Navigator.of(context).maybePop(),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        leadingWidth: 80,
        title: Text(
          _isEditing ? 'Edit Task' : 'Add New Activities',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            Consumer(
              builder: (context, ref, child) => IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () => _confirmDelete(context, ref),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildImageUploadArea(),
            const SizedBox(height: 20),
            _buildLabel('TASK TITLE'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'What need to be done?',
                hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 1)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              style: GoogleFonts.inter(fontSize: 15),
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter a task title'
                  : null,
            ),
            const SizedBox(height: 16),
            _buildLabel('DESCRIPTION'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add more details...',
                hintStyle: GoogleFonts.inter(
                    color: Colors.grey.shade400, fontSize: 14),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary, width: 2)),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: GoogleFonts.inter(fontSize: 15),
            ),
            const SizedBox(height: 16),
            _buildLabel('SCHEDULE'),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () async {
                await _pickDate();
                if (_dueDate != null) await _pickTime();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _formatSchedule(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: (_dueDate != null || _dueTime != null)
                              ? AppColors.textPrimary
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textSecondary, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildLabel('PRIORITY'),
            const SizedBox(height: 8),
            _buildPriorityToggle(),
            const SizedBox(height: 16),
            _buildLabel('CATEGORY'),
            const SizedBox(height: 8),
            _buildCategoryChips(),
            const SizedBox(height: 16),
            _buildLabel('SUBTASKS'),
            const SizedBox(height: 8),
            _buildSubtasksList(),
            const SizedBox(height: 32),
            Consumer(
              builder: (context, ref, child) => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _saveTask(context, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(
                    _isEditing ? 'Update Task' : 'Save to Task',
                    style: GoogleFonts.inter(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildImageUploadArea() {
    if (_imagePath != null) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(File(_imagePath!),
                height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => setState(() => _imagePath = null),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.grey.shade300,
              width: 1.5,
              style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle),
              child: const Icon(Icons.cloud_upload_outlined,
                  color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 10),
            Text('Browse or Drag Image here.',
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text('Free Image or URL',
                style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityToggle() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: Priority.values.map((p) {
          final isSelected = _selectedPriority == p;
          final label = p == Priority.low
              ? 'Low'
              : p == Priority.medium
                  ? 'Medium'
                  : 'High';
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedPriority = p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return GestureDetector(
          onTap: () => setState(() => _selectedCategory = cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade300),
            ),
            child: Text(
              cat,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubtasksList() {
    return Column(
      children: [
        ..._subtasks.asMap().entries.map((entry) {
          final index = entry.key;
          final subtask = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(Icons.radio_button_unchecked,
                    color: Colors.grey.shade400, size: 20),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(subtask,
                        style: GoogleFonts.inter(
                            fontSize: 14, color: AppColors.textPrimary))),
                GestureDetector(
                  onTap: () => setState(() => _subtasks.removeAt(index)),
                  child:
                      Icon(Icons.close, color: Colors.grey.shade400, size: 18),
                ),
              ],
            ),
          );
        }),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              const Icon(Icons.add, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _subtaskController,
                  decoration: InputDecoration(
                    hintText: 'add subtask',
                    hintStyle: GoogleFonts.inter(
                        color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: GoogleFonts.inter(fontSize: 14),
                  onSubmitted: _addSubtask,
                ),
              ),
              TextButton(
                onPressed: () => _addSubtask(_subtaskController.text),
                child: Text('+ add subtask',
                    style: GoogleFonts.inter(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _dueTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        _dueTime = time;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'task_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage =
          await File(pickedFile.path).copy('${appDir.path}/$fileName');

      setState(() {
        _imagePath = savedImage.path;
      });
    }
  }

  void _addSubtask(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        _subtasks.add(value.trim());
        _subtaskController.clear();
      });
    }
  }

  Future<void> _saveTask(BuildContext context, WidgetRef ref) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      DateTime? finalDueDate;
      if (_dueDate != null) {
        finalDueDate = _dueDate;
        if (_dueTime != null) {
          finalDueDate = DateTime(
            _dueDate!.year,
            _dueDate!.month,
            _dueDate!.day,
            _dueTime!.hour,
            _dueTime!.minute,
          );
        }
      }

      final task = _isEditing
          ? widget.taskToEdit!.copyWith(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              priority: _selectedPriority,
              category: _selectedCategory,
              dueDate: finalDueDate,
              imagePath: _imagePath,
              subtasks: List.from(_subtasks),
            )
          : TaskModel.create(
              title: _titleController.text.trim(),
              description: _descriptionController.text.trim(),
              priority: _selectedPriority,
              category: _selectedCategory,
              dueDate: finalDueDate,
              imagePath: _imagePath,
              subtasks: List.from(_subtasks),
            );

      final success = _isEditing
          ? await ref.read(taskNotifierProvider.notifier).updateTask(task)
          : await ref.read(taskNotifierProvider.notifier).addTask(task);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isEditing
                  ? 'Task updated successfully!'
                  : 'Task added successfully!',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        if (mounted) {
          Navigator.of(context).maybePop();
        }
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to save task. Check logs for details.',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: $e',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Task?',
          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete this task? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final success = await ref
            .read(taskNotifierProvider.notifier)
            .deleteTask(widget.taskToEdit!.id);

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Task deleted successfully',
                style: GoogleFonts.inter(),
              ),
              backgroundColor: Colors.green,
            ),
          );
          if (mounted) {
            Navigator.of(context).maybePop();
          }
        }
      } catch (e) {
        debugPrint('Error deleting task: $e');
      }
    }
  }
}
