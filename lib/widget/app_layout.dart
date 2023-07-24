import 'package:flutter/material.dart';
import 'package:flutter_interview_questions/style/color.dart';

class AppLayout extends StatelessWidget {
  final Widget body;
  const AppLayout({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width <= 500;
    return Scaffold(
      backgroundColor: ColorPlate.lightGray,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 800),
          width: double.infinity,
          margin: isMobile ? EdgeInsets.zero : const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorPlate.white,
            borderRadius: BorderRadius.circular(isMobile ? 0 : 12),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: body,
        ),
      ),
    );
  }
}
