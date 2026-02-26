// SearchBar Widget - Flutter equivalent of React Native SearchBar.tsx
// Search input field with icon and clear functionality

import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChangeText;
  final String placeholder;

  const SearchBarWidget({
    super.key,
    required this.value,
    required this.onChangeText,
    required this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChangeText,
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
          suffixIcon: value.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.grey[400],
                  ),
                  onPressed: () => onChangeText(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }
}
