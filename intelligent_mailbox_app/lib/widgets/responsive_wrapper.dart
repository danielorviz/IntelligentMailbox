import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const ResponsiveWrapper({
    super.key,
    required this.child,
    this.maxWidth = 700,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb
        ? Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: child,
          ),
        )
        : child;
  }
}
