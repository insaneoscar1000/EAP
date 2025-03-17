import 'package:flutter/material.dart';

class ProcessAccordion extends StatefulWidget {
  final String title;
  final String content;
  final Color backgroundColor;

  const ProcessAccordion({
    Key? key,
    required this.title,
    required this.content,
    this.backgroundColor = const Color(0xFFBFB5A4), // Beige color from design
  }) : super(key: key);

  @override
  State<ProcessAccordion> createState() => _ProcessAccordionState();
}

class _ProcessAccordionState extends State<ProcessAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            title: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            iconColor: Colors.white,
            collapsedIconColor: Colors.white,
            onExpansionChanged: (expanded) {
              setState(() {
                _isExpanded = expanded;
              });
            },
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  top: 8,
                ),
                child: Text(
                  widget.content,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
