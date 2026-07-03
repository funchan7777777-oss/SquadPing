import 'package:flutter/material.dart';

class GateCopyCluster extends StatelessWidget {
  const GateCopyCluster({
    super.key,
    required this.heading,
    required this.primaryLine,
    required this.secondaryLine,
    this.topOffset = 150,
  });

  final String heading;
  final String primaryLine;
  final String secondaryLine;
  final double topOffset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 30,
      right: 24,
      top: topOffset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
              fontWeight: FontWeight.w600,
              height: 1.05,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 46),
          Text(
            primaryLine,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            secondaryLine,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
              height: 1.2,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
