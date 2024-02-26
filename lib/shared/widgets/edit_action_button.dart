import 'package:flutter/material.dart';

class EditActionButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;

  const EditActionButton({
    required this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () => onPressed(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 26.0,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              SizedBox(height: 2.0),
              Text(
                text,
                style: Theme.of(context).textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
