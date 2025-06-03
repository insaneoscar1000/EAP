import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SearchInput extends StatefulWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;
  final String initialValue;
  final bool showClearButton;
  final Color? borderColor;

  const SearchInput({
    Key? key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
    this.onClear,
    this.initialValue = '',
    this.showClearButton = false,
    this.borderColor,
  }) : super(key: key);

  @override
  _SearchInputState createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(SearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller text if initialValue changes and we're not using an external controller
    if (widget.controller == null &&
        oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.borderColor ?? Theme.of(context).primaryColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller ?? _controller,
        cursorColor: Theme.of(context).primaryColor,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            IconsaxPlusLinear.search_normal,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
          suffixIcon: widget.showClearButton &&
                  (widget.controller?.text.isNotEmpty == true ||
                      _controller.text.isNotEmpty)
              ? IconButton(
                  icon: Icon(
                    IconsaxPlusLinear.close_circle,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  onPressed: () {
                    if (widget.controller != null) {
                      widget.controller!.clear();
                    } else {
                      _controller.clear();
                    }
                    if (widget.onChanged != null) widget.onChanged!('');
                    if (widget.onClear != null) widget.onClear!();
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          fillColor: Theme.of(context).primaryColorLight,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}
