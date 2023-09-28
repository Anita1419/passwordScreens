import 'package:flutter/material.dart';

class InputModeButton extends StatelessWidget {
    final Duration animationDuration;

  final bool simpleInputMode;
  final VoidCallback onModeChanged;
  const InputModeButton({
    super.key, 
    required this.simpleInputMode, 
    required this.onModeChanged, required this.animationDuration});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      alignment: Alignment.centerLeft,
      firstCurve: Curves.easeInOutCubic,
      secondCurve: Curves.easeInOutCubic,
      firstChild: Button(label: 'Original', onTap: onModeChanged),
      secondChild: Button(label: 'Simplify', onTap: onModeChanged),
      crossFadeState: simpleInputMode
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: animationDuration,
    );
   
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
   required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;



  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: onTap,
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}