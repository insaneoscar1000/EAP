import 'package:flutter/material.dart';

class DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const DefaultAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.backgroundColor,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).primaryColorLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: Icon(Icons.chevron_left,
                  size: 34, color: Theme.of(context).primaryColorLight),
              onPressed: () => Navigator.pop(context),
            )
          : Container(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
