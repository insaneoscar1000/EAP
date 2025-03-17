import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final VoidCallback onTap;
  final Color? borderColor;
  final bool enabled;

  const MenuItem({
    Key? key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
    this.borderColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: enabled ? Colors.grey[50] : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Theme.of(context).primaryColor.withOpacity(0.1),
            highlightColor: Theme.of(context).primaryColor.withOpacity(0.1),
          ),
          child: ListTile(
            onTap: enabled ? onTap : null,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: icon != null
                ? Icon(
                    icon,
                    size: 24,
                    color: enabled ? Colors.black87 : Colors.black45,
                  )
                : null,
            trailing: Icon(
              Icons.chevron_right,
              size: 20,
              color: enabled ? Colors.black54 : Colors.black38,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: enabled ? Colors.black87 : Colors.black45,
              ),
            ),
            subtitle: subtitle != null
                ? Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: enabled ? Colors.black54 : Colors.black38,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
