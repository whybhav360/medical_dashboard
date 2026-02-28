import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String text;
  final ImageProvider image;
  final double? width;
  final double? height;
  const StatCard({super.key, required this.text, required this.image, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ]),
      child: Column(
        children: [
          Text(text),
          const SizedBox(height: 5,),
          Image(
            image: ResizeImage(image, width: 210, height: 210),
            width: 70,
            height: 70,
          ),
        ],
      ),
    );
  }
}
