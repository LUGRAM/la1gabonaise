import 'package:flutter/material.dart';
import '../../home/model/content_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/content_image.dart';

// ─────────────────────────────────────────────
// Card portrait  110 × 155 (catalogue, trending)
// ─────────────────────────────────────────────
class ContentCardPortrait extends StatelessWidget {
  final ContentModel content;
  final VoidCallback? onTap;
  final int? rank;

  const ContentCardPortrait({super.key, required this.content, this.onTap, this.rank});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 110,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            // ── Image ──────────────────────────
            ContentImage(
              content: content,
              width: 110, height: 155,
              borderRadius: BorderRadius.circular(10),
            ),

            // ── Badge LIVE ─────────────────────
            if (content.isLive)
              Positioned(top: 6, left: 6, child: _Badge(
                  label: '● LIVE', color: AppColors.primary)),

            // ── Badge 🇬🇦 ──────────────────────
            if (content.isGabonese && !content.isLive)
              Positioned(top: 6, left: 6, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text('🇬🇦', style: TextStyle(fontSize: 9)),
              )),

            // ── Badge EXCLUSIF ─────────────────
            if (content.isExclusive)
              Positioned(top: 6, right: 6, child: _Badge(
                  label: '★ EXCLU', color: AppColors.gold)),

            // ── Numéro classement ──────────────
            if (rank != null)
              Positioned(bottom: 2, left: 4, child: Text(
                '$rank',
                style: const TextStyle(
                    fontFamily: 'Playfair', fontSize: 48,
                    color: Color(0x30FFFFFF), fontWeight: FontWeight.w900, height: 1),
              )),

            // ── Barre de progression ───────────
            if (content.progressPercent != null)
              Positioned(bottom: 0, left: 0, right: 0, child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: (content.progressPercent ?? 0) / 100,
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceHigh,
                  color: AppColors.primary,
                ),
              )),
          ]),

          const SizedBox(height: 6),
          Text(content.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 1),
          Text(content.typeLabel,
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontFamily: 'monospace')),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card landscape  180 × 100 (continue watching, live)
// ─────────────────────────────────────────────
class ContentCardLandscape extends StatelessWidget {
  final ContentModel content;
  final VoidCallback? onTap;

  const ContentCardLandscape({super.key, required this.content, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 200,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ContentImage(
              content: content,
              useBanner: true,       // banner 16:9 pour les cards paysage
              width: 200, height: 112,
              borderRadius: BorderRadius.circular(10),
            ),
            if (content.isLive)
              Positioned(top: 6, left: 6, child: _Badge(
                  label: '● EN DIRECT', color: AppColors.primary)),

            if (content.progressPercent != null)
              Positioned(bottom: 0, left: 0, right: 0, child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                child: LinearProgressIndicator(
                  value: (content.progressPercent ?? 0) / 100,
                  minHeight: 3,
                  backgroundColor: AppColors.surfaceHigh,
                  color: AppColors.primary,
                ),
              )),

            // Overlay gradient bas
            Positioned(bottom: 0, left: 0, right: 0, child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            )),
          ]),
          const SizedBox(height: 6),
          Text(content.title,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              maxLines: 1, overflow: TextOverflow.ellipsis),
          if (content.progressPercent != null)
            Text('${content.progressPercent}% regardé',
                style: const TextStyle(fontSize: 9, color: AppColors.textMuted, fontFamily: 'monospace')),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Card hero  pleine largeur (home banner)
// ─────────────────────────────────────────────
class ContentCardHero extends StatelessWidget {
  final ContentModel content;
  final VoidCallback? onPlay;
  final VoidCallback? onInfo;

  const ContentCardHero({super.key, required this.content, this.onPlay, this.onInfo});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      // Bannière
      ContentImage(
        content: content,
        useBanner: true,
        width: double.infinity,
        height: 320,
      ),

      // Gradient bas
      Positioned(bottom: 0, left: 0, right: 0, child: Container(
        height: 200,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.transparent, AppColors.bg],
          ),
        ),
      )),

      // Contenu textuel
      Positioned(bottom: 16, left: 20, right: 20, child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Badges
        Row(children: [
          if (content.isExclusive) ...[
            _Badge(label: '★ EXCLUSIF', color: AppColors.gold),
            const SizedBox(width: 6),
          ],
          if (content.isGabonese)
            _Badge(label: '🇬🇦 GABON', color: AppColors.primary),
        ]),
        const SizedBox(height: 6),
        Text(content.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
                color: Colors.white, height: 1.1)),
        const SizedBox(height: 4),
        Row(children: [
          if (content.rating > 0) ...[
            const Icon(Icons.star_rounded, color: AppColors.gold, size: 12),
            const SizedBox(width: 3),
            Text('${content.rating}',
                style: const TextStyle(fontSize: 11, color: AppColors.gold,
                    fontWeight: FontWeight.w700)),
            const SizedBox(width: 8),
          ],
          Text(content.typeLabel,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                  fontFamily: 'monospace')),
          if (content.year != null) ...[
            const SizedBox(width: 8),
            Text('${content.year}',
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                    fontFamily: 'monospace')),
          ],
        ]),
        const SizedBox(height: 12),
        Row(children: [
          ElevatedButton.icon(
            onPressed: onPlay,
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: const Text('Regarder', style: TextStyle(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white, foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            onPressed: onInfo,
            icon: const Icon(Icons.info_outline_rounded, size: 18, color: Colors.white70),
            label: const Text('Détails', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.white30),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ]),
      ],
      )),
    ]);
  }
}

// ── Petit badge ────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
    child: Text(label,
        style: const TextStyle(fontSize: 8, color: Colors.white,
            fontFamily: 'monospace', fontWeight: FontWeight.w700, letterSpacing: 0.5)),
  );
}