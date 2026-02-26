// FilterTabs Widget - Flutter equivalent of React Native FilterTabs.tsx
// Tab buttons for filtering tasks (All/Pending/Completed)

import 'package:flutter/material.dart';
import '../providers/task_provider.dart';

class FilterTabs extends StatelessWidget {
  final FilterType value;
  final ValueChanged<FilterType> onChange;

  const FilterTabs({
    super.key,
    required this.value,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab('All', FilterType.all),
          const SizedBox(width: 8),
          _buildTab('Pending', FilterType.pending),
          const SizedBox(width: 8),
          _buildTab('Completed', FilterType.completed),
        ],
      ),
    );
  }

  Widget _buildTab(String label, FilterType filterType) {
    final isActive = value == filterType;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onChange(filterType),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.deepPurple : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isActive ? Colors.deepPurple : Colors.grey[300]!,
              width: 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.deepPurple.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
