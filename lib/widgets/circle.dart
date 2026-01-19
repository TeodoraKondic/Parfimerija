import 'package:flutter/material.dart';

class StatCircleWidget extends StatefulWidget {
  final double endValue; 
  final String label;
  final Color color;
  final String suffix; 

  const StatCircleWidget({
    super.key,
    required this.endValue,
    required this.label,
    required this.color,
    this.suffix = "",
  });

  @override
  State<StatCircleWidget> createState() => _StatCircleWidgetState();
}

class _StatCircleWidgetState extends State<StatCircleWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // Trajanje animacije
    );

    _animation = Tween<double>(begin: 0, end: widget.endValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutExpo),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {

        String displayValue;
        if (_animation.value >= 1000) {
          displayValue = "${(_animation.value / 1000).toStringAsFixed(1)}k";
        } else {
          displayValue = _animation.value.toInt().toString();
        }

        return Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withValues(alpha: 0.15),
            border: Border.all(color: widget.color, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$displayValue${widget.suffix}",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: widget.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: widget.color,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
