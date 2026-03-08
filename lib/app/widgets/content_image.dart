import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../features/home/model/content_model.dart';
import '../theme/app_colors.dart';

/// Widget universel pour afficher l'image d'un ContentModel.
/// Gère automatiquement : URL réseau → asset local → emoji fallback.
class ContentImage extends StatelessWidget {
  final ContentModel content;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final bool useBanner; // false = cover portrait, true = banner 16:9

  const ContentImage({
    super.key,
    required this.content,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.useBanner = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl    = useBanner ? content.bestBanner    : content.bestThumbnail;
    final isNetwork   = useBanner ? content.isNetworkBanner : content.isNetworkThumbnail;
    final hasLocal    = useBanner
        ? content.localBanner != null
        : content.localAsset != null;

    Widget imageWidget;

    if (imageUrl == null) {
      // Fallback emoji
      imageWidget = _EmojiPlaceholder(content: content, useBanner: useBanner);
    } else if (isNetwork) {
      // Image réseau avec cache
      imageWidget = CachedNetworkImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => _LoadingPlaceholder(content: content),
        errorWidget: (_, __, ___) => hasLocal
            ? Image.asset(content.localAsset!, width: width, height: height, fit: fit)
            : _EmojiPlaceholder(content: content, useBanner: useBanner),
      );
    } else {
      // Asset local
      imageWidget = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, __, ___) =>
            _EmojiPlaceholder(content: content, useBanner: useBanner),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }
    return imageWidget;
  }
}

// ── Shimmer de chargement ──────────────────────────────
class _LoadingPlaceholder extends StatefulWidget {
  final ContentModel content;
  const _LoadingPlaceholder({required this.content});

  @override
  State<_LoadingPlaceholder> createState() => _LoadingPlaceholderState();
}

class _LoadingPlaceholderState extends State<_LoadingPlaceholder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Container(
      color: Color.lerp(AppColors.surfaceVar, AppColors.surfaceHigh, _anim.value),
    ),
  );
}

// ── Fallback emoji ─────────────────────────────────────
class _EmojiPlaceholder extends StatelessWidget {
  final ContentModel content;
  final bool useBanner;
  const _EmojiPlaceholder({required this.content, required this.useBanner});

  static const _gradients = [
    [Color(0xFF1a1a2e), Color(0xFF16213e)],
    [Color(0xFF1a0a00), Color(0xFF2d1200)],
    [Color(0xFF0a1a00), Color(0xFF122d00)],
    [Color(0xFF1a001a), Color(0xFF2d002d)],
    [Color(0xFF001a1a), Color(0xFF002d2d)],
    [Color(0xFF1a0003), Color(0xFF2d0005)],
  ];

  @override
  Widget build(BuildContext context) {
    final pair = _gradients[content.id % _gradients.length];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: pair,
        ),
      ),
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(content.emoji,
              style: TextStyle(fontSize: useBanner ? 56 : 36)),
          if (useBanner) ...[
            const SizedBox(height: 8),
            Text(content.title,
                style: const TextStyle(fontSize: 14, color: Colors.white70,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.center, maxLines: 2,
                overflow: TextOverflow.ellipsis),
          ],
        ]),
      ),
    );
  }
}