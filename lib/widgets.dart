import 'package:flutter/material.dart';

class ProductivityButton extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final VoidCallback onPressed;

  const ProductivityButton({required this.color, required this.text, required this.onPressed, required this.size, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: onPressed,
        color: color,
        minWidth: size,
        child:Text(text, style: const TextStyle(color: Colors.white)));
  }
}

typedef CallbackSetting = void Function(String, int);

class SettingsButton extends StatelessWidget {
  final Color color;
  final String text;
  final int value;
  final double size;
  final String setting;
  final CallbackSetting callback;

  const SettingsButton({required this.color, required this.text, required this.value, required this.size, required this.setting, required this.callback, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      onPressed: () => callback(setting, value),
      minWidth: size,
      child:Text(text, style: const TextStyle(color: Colors.white))
    );
  }
}
