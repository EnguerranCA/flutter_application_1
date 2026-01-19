import 'package:flutter/material.dart';

// Couleurs neomorphiques pour la cohérence
const Color kBackgroundColor = Color(0xFFE8F4F8);
const Color kCardColor = Color(0xFFF0F8FF);
const Color kProgressColor = Color(0xFF7BA8C4);
const Color kProgressBg = Color(0xFFD8E8F0);
const Color kShadowLight = Color(0xFFFFFFFF);
const Color kShadowDark = Color(0xFFCBDDE9);

class ProgressionBar extends StatelessWidget {
  final double current;
  final double total;

  const ProgressionBar({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    final progress = current / total;
    
    return Column(
      children: [
        const SizedBox(height: 8),
        Text(
          'Question ${current.toInt() + 1} sur ${total.toInt()}',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2C5F75),
          ),
        ),
        const SizedBox(height: 16),
        // Container externe avec effet neomorphique enfoncé
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: kCardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // Ombre intérieure simulée
              BoxShadow(
                color: kShadowDark.withOpacity(0.5),
                offset: const Offset(3, 3),
                blurRadius: 6,
                spreadRadius: -2,
              ),
              BoxShadow(
                color: kShadowLight.withOpacity(0.7),
                offset: const Offset(-2, -2),
                blurRadius: 4,
                spreadRadius: -1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 20,
              backgroundColor: kProgressBg,
              valueColor: AlwaysStoppedAnimation<Color>(kProgressColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}


