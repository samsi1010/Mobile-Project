import 'package:flutter/material.dart';


class UserTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(12)
        ),
        child: Row(
          children: [
            // ikon
            Icon(Icons.person),
            Text(text),
          ],
        ),
        
      ),
    );
  }
}