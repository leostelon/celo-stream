import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Color? backgroundColor;
  final Color? fontColor;
  final Function()? onClick;
  final bool loading;
  const Button({
    super.key,
    required this.title,
    this.backgroundColor = Colors.white,
    this.fontColor = Colors.black87,
    this.onClick,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          if (loading || onClick == null) return;
          onClick!();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: loading
                ? const SizedBox(
                    height: 18.0,
                    width: 18.0,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    )),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      color: fontColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
