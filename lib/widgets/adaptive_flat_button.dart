import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final VoidCallback handler;

  AdaptiveButton(this.text, this.handler);


  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
        onPressed: handler,
        child: Text(
            'Choose Date',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            )
        ),

    )
        : TextButton(
      onPressed: handler,
      child: Text(
        'Choose Date',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
