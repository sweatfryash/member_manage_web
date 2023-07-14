import 'package:flutter/material.dart';
import 'package:member_manage_web/main.dart';

class BrightnessButton extends StatefulWidget {
  const BrightnessButton({super.key});

  @override
  State<BrightnessButton> createState() => _BrightnessButtonState();
}

class _BrightnessButtonState extends State<BrightnessButton> {
  bool isDarkModeButtonHovered = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: appBrightness,
      builder: (context, brightness, _) {
        IconData iconData;
        if (brightness == Brightness.light) {
          if (isDarkModeButtonHovered) {
            iconData = Icons.dark_mode;
          } else {
            iconData = Icons.dark_mode_outlined;
          }
        } else {
          if (isDarkModeButtonHovered) {
            iconData = Icons.light_mode;
          } else {
            iconData = Icons.light_mode_outlined;
          }
        }
        return OutlinedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
          ),
          onPressed: () {
            if (brightness == Brightness.light) {
              appBrightness.value = Brightness.dark;
            } else {
              appBrightness.value = Brightness.light;
            }
          },
          onHover: (bool value) {
            setState(() {
              isDarkModeButtonHovered = value;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(iconData),
          ),
        );
      },
    );
  }
}
