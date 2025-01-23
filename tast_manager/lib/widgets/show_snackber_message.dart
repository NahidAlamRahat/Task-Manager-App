import 'package:flutter/material.dart';

// Custom function to show a SnackBar with the provided message.
Mymessage(message, context) {
  // Display a SnackBar with the message
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),  // Display the text in the SnackBar
  );
}
