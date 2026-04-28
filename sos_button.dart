import 'package:flutter/material.dart';
import '../config/theme.dart';

class SOSButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isActive;

  const SOSButton({
    super.key,
    required this.onPressed,
    this.isActive = false,
  });

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isActive ? 1.0 : _pulseAnimation.value,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.alertGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.4),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.emergency_rounded, color: Colors.white, size: 48),
                  const SizedBox(height: 8),
                  Text(
                    widget.isActive ? 'ACTIVE' : 'SOS',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
