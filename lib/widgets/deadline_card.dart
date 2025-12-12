import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';

class DeadlineCard extends StatefulWidget {
  final String id;
  final String title;
  final String subject;
  final DateTime deadline;
  final String description;
  final bool isUrgent;

  const DeadlineCard({
    super.key,
    required this.id,
    required this.title,
    required this.subject,
    required this.deadline,
    required this.description,
    required this.isUrgent,
  });

  @override
  State<DeadlineCard> createState() => _DeadlineCardState();
}

class _DeadlineCardState extends State<DeadlineCard> {
  late Timer _timer;
  Duration _timeLeft = Duration.zero;
  bool _isPanicMode = false;

  @override
  void initState() {
    super.initState();
    _calculateTimeLeft();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeLeft();
    });
  }

  void _calculateTimeLeft() {
    setState(() {
      final now = DateTime.now();
      final difference = widget.deadline.difference(now);
      
      if (difference.isNegative) {
        _timeLeft = Duration.zero;
        _isPanicMode = false; // Or handle expired differently
      } else {
        _timeLeft = difference;
        // Panic if < 24 hours (86400 seconds)
        _isPanicMode = difference.inSeconds < 86400;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final isMaroon = theme.currentTheme == AppTheme.maroon;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.navbarBorderColor ?? Colors.transparent, 
          width: 1
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accentColor.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Badge
            _buildSplitBadge(theme),

            const SizedBox(height: 16),

            // Title
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.1,
                color: theme.accentColor, // "Yellow text" as requested (Accent)
                letterSpacing: -0.5,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Timer Cards (Outlined Style)
            _buildOutlinedTimer(theme),

            const SizedBox(height: 24),

            // Info Rows
            _buildInfoRow(theme, Icons.place_outlined, "Venue: ${widget.description.split('\n').firstWhere((l) => l.startsWith('Venue:'), orElse: () => 'TBA').replaceAll('Venue: ', '')}"),
            const SizedBox(height: 8),
            _buildInfoRow(theme, Icons.assignment_outlined, "Deliverables: ${widget.description.split('\n').firstWhere((l) => l.startsWith('Deliverables:'), orElse: () => 'None').replaceAll('Deliverables: ', '')}"),

            const SizedBox(height: 32),

            // Pill Footer
            _buildPillFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSplitBadge(ThemeProvider theme) {
    // Robust splitting: Try space, then hyphen, else just use the whole string as dept
    String dept = widget.subject;
    String num = '';

    if (widget.subject.contains(' ')) {
      final parts = widget.subject.split(' ');
      dept = parts[0];
      if (parts.length > 1) num = parts.sublist(1).join(' ');
    } else if (widget.subject.contains('-')) {
       final parts = widget.subject.split('-');
       dept = parts[0];
       if (parts.length > 1) num = parts[1];
    } else if (widget.subject.length > 3 && widget.subject.substring(0, 2).toUpperCase() == widget.subject.substring(0, 2)) {
      // Heuristic for things like "CS3110" -> "CS" "3110"
      // This is a simple guess, might be better to just leave it if no separator.
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent, 
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Department Part (Colored)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.accentColor,
              borderRadius: num.isNotEmpty 
                ? const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )
                : BorderRadius.circular(8),
            ),
            child: Text(
              dept,
              style: theme.getNumberStyle(
                color: theme.backgroundColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          // Number Part (Grey/Dark) - Only show if we parsed a number
          if (num.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: theme.cardSecondaryTextColor.withOpacity(0.1), // Fixed: Use cardSecondary (visible on white)
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: theme.cardSecondaryTextColor.withOpacity(0.1)),
              ),
              child: Text(
                num,
                style: theme.getNumberStyle(
                  color: theme.cardSecondaryTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              ),

        ],
      ),
    );
  }

  Widget _buildOutlinedTimer(ThemeProvider theme) {
    // Breakdown time
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Days Section (Left Side)
        if (days > 0) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "$days", 
                style: theme.getNumberStyle(
                  fontSize: 78, 
                  fontWeight: FontWeight.bold,
                  height: 0.9,
                  color: theme.accentColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                days == 1 ? "DAY" : "DAYS",
                style: TextStyle(
                  fontSize: 22, // Larger label
                  fontWeight: FontWeight.w900,
                  color: theme.accentColor,
                ),
              ),
            ],
          ),
          
          const SizedBox(width: 16), // Increased padding

          // Separator (Two Hollow Circles)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.accentColor, width: 2),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: theme.accentColor, width: 2),
                ),
              ),
            ],
          ),

          const SizedBox(width: 16), // Increased padding
        ],

        // H : M : S Boxes
        _buildTimeBlock(theme, hours, "h"),
        const SizedBox(width: 6),
        _buildTimeBlock(theme, minutes, "m"),
        const SizedBox(width: 6),
        _buildTimeBlock(theme, seconds, "s"),
      ],
    );
  }

  Widget _buildTimeBlock(ThemeProvider theme, int value, String label) {
    // Slanted Corner Style (Image 1 reference)
    const double cornerSize = 50.0; 

    return Expanded( // Restored Expanded to fill the gap on the right
      child: SizedBox(
        height: 120, // Increased height to make it "bigger"
        child: CustomPaint(
          painter: SlantedCornerPainter(
            color: theme.accentColor,
            backgroundColor: theme.cardBackgroundColor,
            cornerSize: cornerSize,
            fillCorner: true, 
          ),
          child: Stack(
            children: [
              // Number centered
              Positioned.fill(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16, right: 16, left: 4, top: 4), 
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value.toString().padLeft(2, '0'),
                        style: theme.getNumberStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: theme.accentColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Label in bottom-right filled area: Using Alignment at 0.35 inside the corner box
              Positioned(
                right: 0,
                bottom: 0,
                width: cornerSize,
                height: cornerSize,
                child: Align(
                  alignment: const Alignment(0.6, 0.6), // Moved further bottom-right
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 20, // Increased from 16
                      fontWeight: FontWeight.w900,
                      color: theme.cardBackgroundColor, 
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Separator is no longer needed in this specific design preference (Image 1 has stand-alone boxes)
  // But keeping a dummy method or removing usage in row is fine. I removed usage in Row just now.



  Widget _buildInfoRow(ThemeProvider theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.accentColor), // Yellow Icon
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.cardTextColor, // Main text color (usually white/black)
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPillFooter(ThemeProvider theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // No border/gradient for this specific minimal style reference, just info + button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                "Due: ",
                style: TextStyle(
                  color: theme.cardTextColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('MMM d').format(widget.deadline) + " at " + DateFormat('h:mm a').format(widget.deadline),
                style: TextStyle(
                  color: theme.cardTextColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          
          // Action Arrow
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.accentColor, // Yellow Button
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward,
              color: theme.backgroundColor, // Dark arrow on yellow
              size: 20,
            ),
          )
        ],
      ),
    );
  }
}

class SlantedCornerPainter extends CustomPainter {
  final Color color;
  final Color backgroundColor;
  final double cornerSize;
  final bool fillCorner;

  SlantedCornerPainter({
    required this.color, 
    required this.backgroundColor,
    this.cornerSize = 25.0,
    this.fillCorner = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw the Main Shape (Stroked)
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final double radius = 12.0;

    final path = Path();
    
    // Top Left
    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    
    // Top Edge
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);

    // Right Edge - stops before corner
    path.lineTo(size.width, size.height - cornerSize);
    
    // Diagonal Cut
    path.lineTo(size.width - cornerSize, size.height);
    
    // Bottom Edge
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    
    // Close
    path.close();

    canvas.drawPath(path, paint);

    // 2. Draw the Corner Triangle (Filled)
    if (fillCorner) {
      final fillPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      final trianglePath = Path();
      trianglePath.moveTo(size.width - cornerSize, size.height);
      trianglePath.lineTo(size.width, size.height - cornerSize);
      trianglePath.lineTo(size.width, size.height); // Bottom-right corner
      trianglePath.close();
      
      canvas.drawPath(trianglePath, fillPaint);
    } else {
       // Just the separator line if not filled
       final separatorPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
    
      canvas.drawLine(
        Offset(size.width - cornerSize, size.height), 
        Offset(size.width, size.height - cornerSize), 
        separatorPaint
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
