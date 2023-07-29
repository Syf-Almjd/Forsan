import 'package:flutter/material.dart';
import 'package:forsan/Components/Components.dart';

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: endIcon
          ? Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey.withOpacity(0.1),
              ),
              child:
                  const Icon(Icons.arrow_back, size: 18.0, color: Colors.grey))
          : null,
      title: Align(
          alignment: Alignment.centerRight,
          child: Text(title, style: fontAlmarai())),
      trailing: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.amber,
        ),
        child: Icon(icon, color: Colors.green),
      ),
    );
  }
}
