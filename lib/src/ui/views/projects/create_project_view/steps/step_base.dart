import 'package:flutter/material.dart';
import 'package:the_eap_app/src/core/view_models/projects/create_project_view_model.dart';

abstract class StepBase extends StatelessWidget {
  final CreateProjectViewModel model;
  
  const StepBase({Key? key, required this.model}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return buildStep(context);
  }
  
  Widget buildStep(BuildContext context);
  
  Widget buildFormField({
    required String label,
    required String hintText,
    required Function(String) onChanged,
    int maxLines = 1,
    bool isRequired = false,
    String initialValue = '',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            // Removed required field indicator
          ],
        ),
        SizedBox(height: 8),
        _SyncedTextField(
          initialValue: initialValue,
          maxLines: maxLines,
          hintText: hintText,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// A TextFormField whose text is kept in sync with [initialValue] when that
// value changes out from under it (e.g. project data arriving asynchronously
// after the form has already built), without clobbering text the user is
// actively editing.
class _SyncedTextField extends StatefulWidget {
  final String initialValue;
  final String hintText;
  final int maxLines;
  final Function(String) onChanged;

  const _SyncedTextField({
    required this.initialValue,
    required this.hintText,
    required this.maxLines,
    required this.onChanged,
  });

  @override
  State<_SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<_SyncedTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void didUpdateWidget(_SyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLines: widget.maxLines,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Colors.grey[400]!,
            width: 1,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}
