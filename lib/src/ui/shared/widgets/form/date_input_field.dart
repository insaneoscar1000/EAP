import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final dynamic validator;
  final Color? borderColor;
  final double? borderRadius;

  DateInputField({
    required this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.borderColor,
    this.borderRadius,
  });

  @override
  _DateInputFieldState createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  DateTime? _selectedDate;
  final DateFormat _dateFormat = DateFormat('d MMMM yyyy');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        filled: true,
        fillColor: Theme.of(context).secondaryHeaderColor,
        labelStyle: TextStyle(
          color: Theme.of(context).primaryColorDark,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide:
              BorderSide(color: widget.borderColor ?? Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
          borderSide: BorderSide(color: Theme.of(context).primaryColorDark),
        ),
        suffixIcon: Icon(Icons.calendar_today),
      ),
      validator: widget.validator,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _selectedDate ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Theme.of(context).primaryColor,
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).primaryColor,
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          setState(() {
            _selectedDate = pickedDate;
            widget.controller.text = _dateFormat.format(pickedDate);
          });
        }
      },
    );
  }
}
