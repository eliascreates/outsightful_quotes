import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  const DisplayMessage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(child: child),
    );
  }
}
