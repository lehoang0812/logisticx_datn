import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProgressDialog extends StatelessWidget {
  String? message;
  ProgressDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 6,
            ),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
            ),
            SizedBox(
              width: 26.0,
            ),
            Text(
              message!,
              style: TextStyle(
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}
