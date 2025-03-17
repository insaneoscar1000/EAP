import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class SearchInput extends StatelessWidget {
  final String? hintText;
  final Function(String)? onChanged;
  final TextEditingController? controller;

  const SearchInput({
    Key? key,
    this.hintText = 'Search...',
    this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor,
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
        controller: controller,
        cursorColor: Theme.of(context).primaryColor,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 16,
          ),
          prefixIcon: Icon(
            IconsaxPlusLinear.search_normal,
            color: Theme.of(context).primaryColor,
            size: 22,
          ),
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
