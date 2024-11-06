import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MySnackbar {
  static SnackbarController showErrorSnackbar(String text) {
    Get.closeCurrentSnackbar();
    return Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 5),
        icon: const Icon(
          Icons.error,
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        messageText: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  static SnackbarController showSuccessSnackbar(String text) {
    Get.closeCurrentSnackbar();
    return Get.showSnackbar(
      GetSnackBar(
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 5),
        icon: const Icon(
          Icons.done,
          color: Colors.white,
        ),
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        messageText: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
