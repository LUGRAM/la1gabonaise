import 'package:flutter/material.dart';
import '../../home/model/content_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/content_image.dart';

class HomeHero extends StatelessWidget {
  final ContentModel content;
  final VoidCallback onPlay;
  final VoidCallback onAdd;

  const HomeHero({super.key, required this.content, required this.onPlay, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 340,
      child: Stack(fit: StackFit.expand, children: [

        // ── Vraie image banner (réseau → local → emoji) ──
        ContentImage(
          content: content,
          useBanner: true,
          fit: BoxFit.cover,
        ),

        // ── Gradient haut (status bar) ───────────────────
        Positioned(top: 0, left: 0, right: 0,
          child: Container(height: 80,
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            )),
          ),
        ),

        // ── Gradient bas (lisibilité texte) ──────────────
        const DecoratedBox(
          decoration: BoxDecoration(gradient: AppColors.heroGrad),
        ),

        // ── Info overlay ─────────────────────────────────
        Positioned(bottom: 0, left: 20, right: 20,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              if (content.isExclusive) _tag('🇬🇦 EXCLUSIF', AppColors.primary),
              const SizedBox(width: 6),
              if (content.genres.isNotEmpty)
                _tag(content.genres.first.toUpperCase(), Colors.transparent, bordered: true),
              const SizedBox(width: 6),
              if (content.year != null)
                _tag('${content.year}', Colors.transparent, bordered: true),
            ]),
            const SizedBox(height: 8),
            Text(content.title, style: AppTextStyles.display1),
            const SizedBox(height: 6),
            Row(children: [
              Text('★ ${content.rating}',
                  style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w700, fontSize: 12)),
              const SizedBox(width: 8),
              Container(width: 3, height: 3,
                  decoration: const BoxDecoration(color: AppColors.textMuted, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Text(content.duration ?? '', style: AppTextStyles.bodySmall),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              GestureDetector(onTap: onPlay,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.play_arrow_rounded, color: Colors.black, size: 20),
                    SizedBox(width: 6),
                    Text('Regarder', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 13)),
                  ]),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(onTap: onAdd,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white12, borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('Ma liste', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ]),
                ),
              ),
            ]),
            const SizedBox(height: 16),
          ]),
        ),
      ]),
    );
  }

  Widget _tag(String label, Color color, {bool bordered = false}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bordered ? Colors.transparent : color,
      borderRadius: BorderRadius.circular(3),
      border: bordered ? Border.all(color: Colors.white30) : null,
    ),
    child: Text(label,
        style: const TextStyle(fontSize: 9, color: Colors.white, fontFamily: 'monospace', letterSpacing: 1.5)),
  );
}