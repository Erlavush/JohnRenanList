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
    final styles = theme.getCardBorder(isPanicMode: _isPanicMode);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: theme.cardBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: styles,
        boxShadow: theme.getCardShadow(isPanicMode: _isPanicMode),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Row: Subject & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSubjectLabel(theme),
                if (_isPanicMode) _buildPanicBadge(theme),
              ],
            ),

            const SizedBox(height: 16),

            // Middle Row: Title & Timer
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: theme.cardTextColor,
              ),
            ),
            
            const SizedBox(height: 12),
            
            _buildTimer(theme),

            const SizedBox(height: 24),

            // Bottom Row: Info & Action
            _buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectLabel(ThemeProvider theme) {
    Color getBg() {
       if (_isPanicMode) {
          if (theme.currentTheme == AppTheme.cyberpunk) return theme.panicColor.withOpacity(0.2);
          if (theme.currentTheme == AppTheme.light) return const Color(0xFFFEE2E2); // red-100
          if (theme.currentTheme == AppTheme.maroon) return theme.panicColor;
       }
       // Normal mode
       if (theme.currentTheme == AppTheme.cyberpunk) return const Color(0xFF1A1A1A);
       if (theme.currentTheme == AppTheme.light) return const Color(0xFFF3F4F6); // gray-100
       if (theme.currentTheme == AppTheme.maroon) return const Color(0xFF6C1606).withOpacity(0.1); 
       return Colors.grey;
    }

    Color getText() {
      if (_isPanicMode) {
         if (theme.currentTheme == AppTheme.cyberpunk) return theme.panicColor;
         if (theme.currentTheme == AppTheme.light) return const Color(0xFFB91C1C); // red-700
         if (theme.currentTheme == AppTheme.maroon) return Colors.black;
      }
      // Normal mode
      if (theme.currentTheme == AppTheme.cyberpunk) return Colors.grey;
      if (theme.currentTheme == AppTheme.light) return const Color(0xFF4B5563); // gray-600
      if (theme.currentTheme == AppTheme.maroon) return const Color(0xFF6C1606); // deep-red
      return Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: getBg(),
        borderRadius: BorderRadius.circular(6),
         border: _isPanicMode && theme.currentTheme == AppTheme.cyberpunk 
            ? Border.all(color: theme.panicColor.withOpacity(0.4)) 
            : null,
      ),
      child: Text(
        widget.subject,
        style: TextStyle(
          fontSize: 10,
          fontFamily: 'Fira Code',
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
          color: getText(),
        ),
      ),
    );
  }

  Widget _buildPanicBadge(ThemeProvider theme) {
    Color getColor() {
       if (theme.currentTheme == AppTheme.light || theme.currentTheme == AppTheme.maroon) return Colors.red;
       return theme.panicColor;
    }
    
    return Row(
      children: [
        Icon(Icons.warning_amber_rounded, size: 14, color: getColor()),
        const SizedBox(width: 4),
        Text(
          "CRITICAL",
          style: TextStyle(
            fontSize: 10, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 1.5,
            color: getColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimer(ThemeProvider theme) {
    final days = _timeLeft.inDays;
    final hours = _timeLeft.inHours % 24;
    final minutes = _timeLeft.inMinutes % 60;
    final seconds = _timeLeft.inSeconds % 60;
    
    Color getColor() {
       if (_isPanicMode) {
         if (theme.currentTheme == AppTheme.light) return const Color(0xFFDC2626); // red-600
         return theme.panicColor;
       }
       return theme.cardTextColor;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (days > 0) ...[
          Text(
            "${days}d",
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontFamily: 'Fira Code',
              color: getColor().withOpacity(0.5),
            ),
          ),
          const SizedBox(width: 12),
        ],
        _buildTimerSegment(hours, getColor()),
        _buildSeparator(getColor()),
        _buildTimerSegment(minutes, getColor()),
        _buildSeparator(getColor()),
        _buildTimerSegment(seconds, getColor()),
      ],
    );
  }

  Widget _buildTimerSegment(int value, Color color) {
    return Text(
      value.toString().padLeft(2, '0'),
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        fontFamily: 'Fira Code',
        height: 1.0,
        color: color,
        // Add glow for cyberpunk
        shadows: color == const Color(0xFFFAF807) ? [
           const BoxShadow(
             color: Color(0xFFFAF807),
             blurRadius: 8,
             spreadRadius: 0,
           )
        ] : null,
      ),
    );
  }
  
  Widget _buildSeparator(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Text(
        ":",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Fira Code',
          color: color.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeProvider theme) {
    final borderColor = (theme.currentTheme == AppTheme.light || theme.currentTheme == AppTheme.maroon)
        ? const Color(0xFFE5E7EB) 
        : const Color(0xFF333333);

    return Container(
      padding: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: borderColor, style: BorderStyle.solid)), // dashed border hard to do simply, solid is fine
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                   widget.description,
                   maxLines: 2,
                   overflow: TextOverflow.ellipsis,
                   style: TextStyle(
                     fontSize: 14,
                     height: 1.5,
                     color: theme.cardSecondaryTextColor,
                   ),
                 ),
                 const SizedBox(height: 8),
                 Row(
                   children: [
                     Text(
                       "ID: ${widget.id.split('-').first}",
                       style: TextStyle(
                         fontFamily: 'Fira Code',
                         fontSize: 10,
                         fontWeight: FontWeight.bold,
                         letterSpacing: 0.5,
                         color: theme.cardSecondaryTextColor.withOpacity(0.6),
                       ),
                     ),
                     const SizedBox(width: 12),
                      Text(
                       "Due: ${DateFormat('M/d/yyyy').format(widget.deadline)}",
                       style: TextStyle(
                         fontFamily: 'Fira Code',
                         fontSize: 10,
                         fontWeight: FontWeight.bold,
                         letterSpacing: 0.5,
                         color: theme.cardSecondaryTextColor.withOpacity(0.6),
                       ),
                     ),
                   ],
                 )
              ],
            ),
          ),
          
          // Arrow Button
          Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent, // hover effect not needed for mobile touch really
             ),
             child: Icon(
               Icons.arrow_forward_rounded,
               color: theme.currentTheme == AppTheme.cyberpunk && _isPanicMode 
                  ? theme.panicColor 
                  : theme.cardSecondaryTextColor,
             ),
          )
        ],
      ),
    );
  }
  
  Color _getTimeColor(ThemeProvider theme, bool isTimer) {
     if (_isPanicMode) {
        if (theme.currentTheme == AppTheme.light) return const Color(0xFFDC2626);
        return theme.panicColor;
     }
     return theme.cardTextColor;
  }
}
