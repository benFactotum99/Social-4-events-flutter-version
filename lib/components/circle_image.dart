import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  final String imageUrl;
  final double sizeMultiplier;

  const CircleImage({
    Key? key,
    required this.imageUrl,
    this.sizeMultiplier = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100 * sizeMultiplier,
      height: 100 * sizeMultiplier,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
