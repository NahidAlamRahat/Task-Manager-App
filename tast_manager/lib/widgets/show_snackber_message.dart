import 'package:flutter/material.dart';

Mymessage(message, context) {
  // Display a SnackBar with the message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}