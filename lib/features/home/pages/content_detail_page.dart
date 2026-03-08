import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/content_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/content_image.dart';
import '../../home/model/data/home_mock.dart';
import '../../../app/routes/app_routes.dart';

class ContentDetailPage extends StatefulWidget {
  const ContentDetailPage({super.key});
  @override
  State<ContentDetailPage> createState() => _ContentDetailPageState();
}

class _ContentDetailPageState extends State<ContentDetailPage>
    with SingleTickerProviderStateMixin {

  late final ContentModel content;
  late final AnimationController _ctrl;
  late final Animation<double> _fadeSlide;
  bool _inList = false;

  // Quelques contenus similaires issus du mock
  List<ContentModel> get _similar => [
    ...kGabonFilms, ...kTrending,
  ].where((c) => c.id != content.id).take(6).toList();

  @override
  void initState() {
    super.initState();
    // Résout le contenu complet (synopsis, cast, etc.)
    content = resolveContent(Get.arguments as ContentModel);
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeSlide = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    // Lance l'animation après le Hero (350ms)
    Future.delayed(const Duration(milliseconds: 350), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          // ── SliverAppBar avec Hero image ─────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.bg,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Get.back(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                  child: const Icon(Icons.share_outlined, color: Colors.white, size: 18),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(fit: StackFit.expand, children: [
                // ── Hero banner ─────────────────────────
                Hero(
                  tag: content.heroBannerTag,
                  child: ContentImage(
                    content: content,
                    useBanner: true,
                    fit: BoxFit.cover,
                  ),
                ),
                // ── Gradient bas ────────────────────────
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.bg],
                      stops: [0.4, 1.0],
                    ),
                  ),
                ),
                // ── Bouton play centré ───────────────────
                Center(child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.player, arguments: content),
                  child: Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: Color(0x26FFFFFF),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white54, width: 2),
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 36),
                  ),
                )),
              ]),
            ),
          ),

          // ── Corps du détail ──────────────────────────────
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeSlide,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.08), end: Offset.zero,
                ).animate(_fadeSlide),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // ── Titre + badges ─────────────────
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: Text(content.title,
                            style: const TextStyle(fontSize: 26,
                                fontWeight: FontWeight.w900, color: Colors.white, height: 1.1))),
                        const SizedBox(width: 12),
                        Hero(
                          tag: content.heroTag,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: ContentImage(
                              content: content,
                              width: 70, height: 100,
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: 10),

                      // ── Méta-infos ─────────────────────
                      Wrap(spacing: 12, runSpacing: 4, children: [
                        if (content.rating > 0)
                          _MetaChip(icon: Icons.star_rounded,
                              color: AppColors.gold,
                              label: '${content.rating}/10'),
                        if (content.year != null)
                          _MetaChip(label: '${content.year}'),
                        if (content.duration != null)
                          _MetaChip(icon: Icons.schedule_rounded, label: content.duration!),
                        if (content.seasons != null)
                          _MetaChip(icon: Icons.layers_rounded,
                              label: '${content.seasons} saisons · ${content.episodes ?? '?'} épisodes'),
                        _MetaChip(label: content.typeLabel, color: AppColors.primary),
                      ]),

                      const SizedBox(height: 12),

                      // ── Genres ─────────────────────────
                      if (content.genres.isNotEmpty)
                        Wrap(spacing: 8, children: content.genres.map((g) =>
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(g, style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted,
                                  fontFamily: 'monospace')),
                            )
                        ).toList()),

                      const SizedBox(height: 20),

                      // ── Boutons CTA ────────────────────
                      Row(children: [
                        Expanded(child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.player, arguments: content),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.play_arrow_rounded, color: Colors.black, size: 22),
                                  SizedBox(width: 6),
                                  Text('Regarder', style: TextStyle(color: Colors.black,
                                      fontWeight: FontWeight.w800, fontSize: 14)),
                                ]),
                          ),
                        )),
                        const SizedBox(width: 10),
                        // Ma liste
                        GestureDetector(
                          onTap: () => setState(() => _inList = !_inList),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: _inList ? AppColors.primary : AppColors.surfaceVar,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: _inList ? AppColors.primary : AppColors.border),
                            ),
                            child: Icon(
                                _inList ? Icons.check_rounded : Icons.add_rounded,
                                color: Colors.white, size: 24),
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Télécharger
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: 52, height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVar,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.download_rounded,
                                color: Colors.white, size: 22),
                          ),
                        ),
                      ]),

                      // ── Description courte ─────────────
                      if (content.description != null) ...[
                        const SizedBox(height: 24),
                        Text(content.description!,
                            style: const TextStyle(fontSize: 14,
                                color: AppColors.textSecondary, height: 1.5)),
                      ],

                      // ── Synopsis ───────────────────────
                      if (content.synopsis != null) ...[
                        const SizedBox(height: 20),
                        const Text('SYNOPSIS',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace',
                                letterSpacing: 2, color: AppColors.textMuted,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        _ExpandableText(text: content.synopsis!),
                      ],

                      // ── Réalisateur ────────────────────
                      if (content.director != null) ...[
                        const SizedBox(height: 24),
                        const Text('RÉALISATEUR',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace',
                                letterSpacing: 2, color: AppColors.textMuted,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Row(children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVar,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Center(child: Text('🎬',
                                style: TextStyle(fontSize: 16))),
                          ),
                          const SizedBox(width: 10),
                          Text(content.director!,
                              style: const TextStyle(fontSize: 14,
                                  color: Colors.white, fontWeight: FontWeight.w600)),
                        ]),
                      ],

                      // ── Casting ────────────────────────
                      if (content.cast.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text('CASTING',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace',
                                letterSpacing: 2, color: AppColors.textMuted,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: content.cast.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 16),
                            itemBuilder: (_, i) => _CastCard(member: content.cast[i]),
                          ),
                        ),
                      ],

                      // ── Similaires ─────────────────────
                      if (_similar.isNotEmpty) ...[
                        const SizedBox(height: 32),
                        const Text('SIMILAIRES',
                            style: TextStyle(fontSize: 10, fontFamily: 'monospace',
                                letterSpacing: 2, color: AppColors.textMuted,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 12),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                          itemCount: _similar.length,
                          itemBuilder: (_, i) {
                            final c = _similar[i];
                            return GestureDetector(
                              onTap: () => Get.off(
                                    () => const ContentDetailPage(),
                                arguments: c,
                                transition: Transition.fadeIn,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: Hero(
                                    tag: 'similar_${c.id}',
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ContentImage(content: c,
                                          width: double.infinity),
                                    ),
                                  )),
                                  const SizedBox(height: 4),
                                  Text(c.title, style: const TextStyle(
                                      fontSize: 10, color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600),
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      // ── Bouton flottant "Regarder" fixe en bas ──────────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0x000A0A0A), AppColors.bg],
          ),
        ),
        child: SafeArea(
          child: ElevatedButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.player, arguments: content),
            icon: const Icon(Icons.play_arrow_rounded, size: 22),
            label: Text(
              content.type == ContentType.serie
                  ? 'Regarder S1É1'
                  : 'Regarder le film',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Texte expandable ─────────────────────────────────────
class _ExpandableText extends StatefulWidget {
  final String text;
  const _ExpandableText({required this.text});
  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}
class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 250),
        firstChild: Text(widget.text,
            maxLines: 4, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
        secondChild: Text(widget.text,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6)),
        crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
      const SizedBox(height: 4),
      GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: Text(_expanded ? 'Voir moins' : 'Lire la suite',
            style: const TextStyle(fontSize: 12, color: AppColors.primary,
                fontWeight: FontWeight.w600)),
      ),
    ],
  );
}

// ── Card membre du cast ──────────────────────────────────
class _CastCard extends StatelessWidget {
  final CastMember member;
  const _CastCard({required this.member});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 52, height: 52,
        decoration: BoxDecoration(
          color: AppColors.surfaceVar,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.border, width: 1.5),
        ),
        child: Center(child: Text(member.emoji,
            style: const TextStyle(fontSize: 22))),
      ),
      const SizedBox(height: 6),
      Text(member.name.split(' ').first,
          style: const TextStyle(fontSize: 10, color: AppColors.textPrimary,
              fontWeight: FontWeight.w600)),
      Text(member.role,
          style: const TextStyle(fontSize: 9, color: AppColors.textMuted,
              fontFamily: 'monospace')),
    ],
  );
}

// ── Chip meta-info ───────────────────────────────────────
class _MetaChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;
  const _MetaChip({required this.label, this.icon, this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color ?? const Color(0x261C1C1C),
      borderRadius: BorderRadius.circular(5),
      border: Border.all(color: color ?? const Color(0x662A2A2A)),
    ),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (icon != null) ...[
        Icon(icon, size: 11, color: color ?? AppColors.textMuted),
        const SizedBox(width: 3),
      ],
      Text(label, style: TextStyle(
          fontSize: 11, color: color ?? AppColors.textSecondary,
          fontWeight: FontWeight.w600, fontFamily: 'monospace')),
    ]),
  );
}