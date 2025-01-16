import 'package:flutter/material.dart';

Mymessage(message,context) {

  ScaffoldMessenger.of(context,).showSnackBar(
      SnackBar(content: Text(message))
  );
}
