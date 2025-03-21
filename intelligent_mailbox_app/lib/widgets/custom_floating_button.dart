import 'package:flutter/material.dart';
import 'package:intelligent_mailbox_app/utils/custom_colors.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final WidgetBuilder pageBuilder;

  const CustomFloatingActionButton({
    super.key,
    required this.pageBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: pageBuilder,
          ),
        );
      },
      backgroundColor: CustomColors.primaryBlue,
      child: const Icon(Icons.add, color: CustomColors.unselectedItem),
    );
  }
}
