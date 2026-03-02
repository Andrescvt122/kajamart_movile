import 'package:flutter/material.dart';

class AdminSectionStyle {
  static const Color pageBackground = Color(0xFFE4EFE8);
  static const Color titleColor = Color(0xFF0E6E54);
  static const Color subtitleColor = Color(0xFF677A70);
  static const Color searchFill = Color(0xFFF0F2F1);
  static const Color searchHint = Color(0xFF95A39D);
  static const Color searchIcon = Color(0xFF9AA8A2);
  static const Color chipSelected = Color(0xFF0A7A5A);
  static const Color chipUnselected = Color(0xFFDCE9E3);
  static const Color chipText = Color(0xFF3C4D46);
  static const Color cardBorder = Color(0xFFC6E8D5);
  static const Color cardTitle = Color(0xFF121B17);
  static const Color cardMuted = Color(0xFF74847D);
  static const Color loader = Color(0xFF0A7A5A);

  static InputDecoration searchDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: searchHint),
      prefixIcon: const Icon(Icons.search, color: searchIcon),
      filled: true,
      fillColor: searchFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    );
  }

  static ChoiceChip filterChip({
    required String label,
    required bool selected,
    required ValueChanged<bool> onSelected,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : chipText,
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: selected,
      selectedColor: chipSelected,
      backgroundColor: chipUnselected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      side: BorderSide.none,
      onSelected: onSelected,
    );
  }
}

class AdminSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdminSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: AdminSectionStyle.titleColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              color: AdminSectionStyle.subtitleColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
