import 'package:flutter/material.dart';

class QuestionAccordion extends StatelessWidget {
  final int index;
  final int? currentExpandedIndex;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final String title;
  final String subtitle;

  const QuestionAccordion({
    Key? key,
    required this.index,
    required this.currentExpandedIndex,
    required this.isExpanded,
    required this.onExpansionChanged,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCurrentlyExpanded = isExpanded && index == currentExpandedIndex;

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isCurrentlyExpanded ? Color(0xFFFFD700) : Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isCurrentlyExpanded,
          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          expandedAlignment: Alignment.topLeft,
          childrenPadding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: 20,
          ),
          onExpansionChanged: onExpansionChanged,
          trailing: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCurrentlyExpanded
                  ? Colors.black.withOpacity(0.1)
                  : Colors.transparent,
            ),
            child: Icon(
              isCurrentlyExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              color: isCurrentlyExpanded ? Colors.black : Colors.grey[400],
              size: 30,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  isCurrentlyExpanded ? FontWeight.w600 : FontWeight.w500,
              color: isCurrentlyExpanded ? Colors.black : Colors.black87,
            ),
          ),
          children: [
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
