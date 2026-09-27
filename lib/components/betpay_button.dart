import 'package:flutter/material.dart';

class BetPayButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  // Button appearance
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  // Button size
  final double width;
  final double height;

  // Text
  final double fontSize;
  final FontWeight fontWeight;

  // Shape
  final double borderRadius;
  final double borderWidth;

  // Icon
  final IconData? icon;
  final bool iconRight;
  final double iconSize;

  // Button type
  final bool outlined;

  const BetPayButton({
    super.key,
    required this.text,
    required this.onPressed,

    this.backgroundColor = const Color(0xFF7A1F3D),
    this.foregroundColor = Colors.white,
    this.borderColor,

    this.width = double.infinity,
    this.height = 54,

    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,

    this.borderRadius = 16,
    this.borderWidth = 1.5,

    this.icon,
    this.iconRight = false,
    this.iconSize = 20,

    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        outlined ? Colors.transparent : backgroundColor;

    final border = outlined
        ? BorderSide(
            color: borderColor ?? backgroundColor,
            width: borderWidth,
          )
        : BorderSide.none;

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: foregroundColor,
          elevation: 0,

          side: border,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
        ),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );

    if (icon == null) {
      return textWidget;
    }

    final iconWidget = Icon(
      icon,
      size: iconSize,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: iconRight
          ? [
              textWidget,
              const SizedBox(width: 8),
              iconWidget,
            ]
          : [
              iconWidget,
              const SizedBox(width: 8),
              textWidget,
            ],
    );
  }
}