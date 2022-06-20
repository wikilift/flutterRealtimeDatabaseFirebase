import 'package:flutter/material.dart';

class NotificationService {
  static late GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey();

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
