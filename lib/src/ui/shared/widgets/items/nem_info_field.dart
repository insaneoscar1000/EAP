import 'package:flutter/material.dart';

/// Labelled read-only text box used on the NEM: Waste / Air Quality detail
/// screens. Empty content is hidden when [hideWhenEmpty] is true.
class NEMInfoField extends StatelessWidget {
  final String title;
  final String content;
  final Color titleColor;
  final bool hideWhenEmpty;

  const NEMInfoField({
    Key? key,
    required this.title,
    required this.content,
    required this.titleColor,
    this.hideWhenEmpty = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hideWhenEmpty && content.trim().isEmpty) return SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              content.isEmpty ? '-' : content,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
