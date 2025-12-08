import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/theme_provider.dart';

class DeadlineCard extends StatefulWidget {
  final String title;
  final String subject;
  final DateTime deadline;
  final bool isUrgent;

  const DeadlineCard({
    super.key,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.isUrgent,
  });

  @override
  State<DeadlineCard> createState() => _DeadlineCardState();
}

class _DeadlineCardState extends State<DeadlineCard> with TickerProviderStateMixin {
  late Timer _timer;
  late Duration _timeLeft;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.deadline.difference(DateTime.now());

    // Bounce animation for warning icon
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _timeLeft = widget.deadline.difference(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _bounceController.dispose();
    super.dispose();
  }

  bool get isPanicMode => _timeLeft.inHours < 24 && !_timeLeft.isNegative;

  String get formattedTime {
    if (_timeLeft.isNegative) return "OVERDUE";
    
    int days = _timeLeft.inDays;
    int hours = _timeLeft.inHours % 24;
    int minutes = _timeLeft.inMinutes % 60;
    int seconds = _timeLeft.inSeconds % 60;

    if (days > 0) {
      return "${days}d ${hours}h ${minutes}m ${seconds}s";
    } else {
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    // Control bounce animation
    if (isPanicMode) {
      if (!_bounceController.isAnimating) {
        _bounceController.repeat(reverse: true);
      }
    } else {
      if (_bounceController.isAnimating) {
        _bounceController.stop();
        _bounceController.reset();
      }
    }

    // Theme-adaptive colors
    final cardBg = theme.cardColor;
    final textColor = theme.textColor;
    final secondaryText = theme.secondaryTextColor;
    final timerColor = isPanicMode ? theme.accentColor : textColor;
    final borderColor = isPanicMode ? theme.panicBorderColor : Colors.transparent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: isPanicMode ? 2 : 0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPanicMode 
                ? theme.panicBorderColor.withOpacity(0.3) 
                : Colors.black.withOpacity(0.2),
            blurRadius: isPanicMode ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Subject Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.accentColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    widget.subject.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: theme.accentColor,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                // Animated Warning Icon (Panic Mode only)
                if (isPanicMode || widget.isUrgent)
                  AnimatedBuilder(
                    animation: _bounceController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, isPanicMode ? _bounceAnimation.value : 0),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: isPanicMode ? theme.panicBorderColor : theme.urgentColor,
                          size: 24,
                        ),
                      );
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            // Timer Display
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  color: timerColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: timerColor,
                    letterSpacing: 2,
                    fontFamily: 'Fira Code',
                  ),
                ),
              ],
            ),
            if (isPanicMode) ...[
              const SizedBox(height: 8),
              Text(
                "⚡ DEADLINE APPROACHING",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: theme.panicBorderColor,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
