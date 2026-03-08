import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../model/content_model.dart';
import '../model/data/home_mock.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/content_image.dart';
import '../../../app/routes/app_routes.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({super.key});
  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage>
    with SingleTickerProviderStateMixin {

  late final String title;
  late final List<ContentModel> allItems;
  late final AnimationController _ctrl;

  String _activeFilter = 'Tous';
  String _activeSort = 'Populaire';
  bool _gridMode = true; // grille ou liste

  static const _sortOptions = ['Populaire', 'Note', 'Récent', 'A-Z'];

  @override
  void initState() {
    super.initState();
    // Reçoit title + items depuis l'appelant
    final args = Get.arguments as Map<String, dynamic>;
    title    = args['title'] as String;
    allItems = List<ContentModel>.from(args['items'] as List);

    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _ctrl.forward();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  // Genres distincts extraits des items
  List<String> get _filters {
    final genres = <String>{'Tous'};
    for (final c in allItems) {
      genres.addAll(c.genres);
    }
    return genres.toList();
  }

  List<ContentModel> get _filtered {
    var list = _activeFilter == 'Tous'
        ? allItems
        : allItems.where((c) => c.genres.contains(_activeFilter)).toList();

    switch (_activeSort) {
      case 'Note':    list.sort((a, b) => b.rating.compareTo(a.rating)); break;
      case 'Récent':  list.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0)); break;
      case 'A-Z':     list.sort((a, b) => a.title.compareTo(b.title)); break;
      default:        break; // Populaire = ordre original
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final items = _filtered;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [

          // ── AppBar ───────────────────────────────────
          SliverAppBar(
            pinned: true,
            backgroundColor: AppColors.bg,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: AppColors.surfaceVar, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 16),
              ),
              onPressed: () => Get.back(),
            ),
            title: Text(title,
                style: const TextStyle(fontFamily: 'Playfair',
                    fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
            centerTitle: false,
            actions: [
              // Toggle grille/liste
              IconButton(
                icon: Icon(
                    _gridMode ? Icons.view_list_rounded : Icons.grid_view_rounded,
                    color: Colors.white70, size: 22),
                onPressed: () => setState(() => _gridMode = !_gridMode),
              ),
              // Tri
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort_rounded, color: Colors.white70, size: 22),
                color: AppColors.surfaceVar,
                onSelected: (v) => setState(() => _activeSort = v),
                itemBuilder: (_) => _sortOptions.map((s) => PopupMenuItem(
                  value: s,
                  child: Row(children: [
                    if (_activeSort == s)
                      const Icon(Icons.check_rounded, size: 14, color: AppColors.primary)
                    else
                      const SizedBox(width: 14),
                    const SizedBox(width: 8),
                    Text(s, style: TextStyle(
                        color: _activeSort == s ? AppColors.primary : Colors.white70,
                        fontSize: 13)),
                  ]),
                )).toList(),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: _FiltersBar(
                filters: _filters,
                active: _activeFilter,
                onTap: (f) => setState(() => _activeFilter = f),
              ),
            ),
          ),

          // ── Compteur ─────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                  '${items.length} titre${items.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                      fontFamily: 'monospace')),
            ),
          ),

          // ── Contenu ───────────────────────────────────
          _gridMode
              ? _GridView(items: items)
              : _ListView(items: items),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }
}

// ── Grille 3 colonnes ─────────────────────────────────────
class _GridView extends StatelessWidget {
  final List<ContentModel> items;
  const _GridView({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyState();
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
              (_, i) => _GridCard(content: items[i]),
          childCount: items.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 10,
          childAspectRatio: 0.62,
        ),
      ),
    );
  }
}

class _GridCard extends StatelessWidget {
  final ContentModel content;
  const _GridCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: content),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Stack(children: [
          Hero(
            tag: 'cat_${content.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ContentImage(
                content: content,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          if (content.isExclusive)
            Positioned(top: 4, right: 4, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: AppColors.gold, borderRadius: BorderRadius.circular(3)),
              child: const Text('★', style: TextStyle(fontSize: 7, color: Colors.white)),
            )),
          if (content.rating > 0)
            Positioned(bottom: 4, left: 4, child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.black54, borderRadius: BorderRadius.circular(3)),
              child: Text('★ ${content.rating}',
                  style: const TextStyle(fontSize: 8, color: AppColors.gold,
                      fontWeight: FontWeight.w700)),
            )),
        ])),
        const SizedBox(height: 5),
        Text(content.title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
                color: AppColors.textPrimary),
            maxLines: 2, overflow: TextOverflow.ellipsis),
        Text(content.typeLabel,
            style: const TextStyle(fontSize: 9, color: AppColors.textMuted,
                fontFamily: 'monospace')),
      ]),
    );
  }
}

// ── Liste ─────────────────────────────────────────────────
class _ListView extends StatelessWidget {
  final List<ContentModel> items;
  const _ListView({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyState();
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (_, i) => _ListCard(content: items[i]),
        childCount: items.length,
      ),
    );
  }
}

class _ListCard extends StatelessWidget {
  final ContentModel content;
  const _ListCard({required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: content),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Row(children: [
          // Cover
          Hero(
            tag: 'cat_list_${content.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ContentImage(content: content, width: 70, height: 100),
            ),
          ),
          const SizedBox(width: 14),
          // Infos
          Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (content.isGabonese)
              const Text('🇬🇦', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 2),
            Text(content.title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
                    color: Colors.white)),
            const SizedBox(height: 4),
            // Genres
            Wrap(spacing: 6, children: content.genres.take(2).map((g) =>
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(g, style: const TextStyle(fontSize: 9,
                      color: AppColors.textMuted, fontFamily: 'monospace')),
                )
            ).toList()),
            const SizedBox(height: 6),
            // Meta
            Row(children: [
              if (content.rating > 0) ...[
                const Icon(Icons.star_rounded, color: AppColors.gold, size: 12),
                const SizedBox(width: 3),
                Text('${content.rating}',
                    style: const TextStyle(fontSize: 11, color: AppColors.gold,
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
              ],
              if (content.year != null)
                Text('${content.year}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                        fontFamily: 'monospace')),
              if (content.duration != null) ...[
                const SizedBox(width: 8),
                Text(content.duration!,
                    style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                        fontFamily: 'monospace')),
              ],
            ]),
            const SizedBox(height: 6),
            if (content.description != null)
              Text(content.description!,
                  style: const TextStyle(fontSize: 11, color: AppColors.textMuted,
                      height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
          ])),
          // Chevron
          const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
        ]),
      ),
    );
  }
}

// ── Filtres horizontaux ───────────────────────────────────
class _FiltersBar extends StatelessWidget {
  final List<String> filters;
  final String active;
  final void Function(String) onTap;
  const _FiltersBar({required this.filters, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      itemCount: filters.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final f = filters[i];
        final selected = f == active;
        return GestureDetector(
          onTap: () => onTap(f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceVar,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: selected ? AppColors.primary : AppColors.border),
            ),
            child: Text(f,
                style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    color: selected ? Colors.white : AppColors.textMuted)),
          ),
        );
      },
    ),
  );
}

// ── État vide ─────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => const SliverFillRemaining(
    child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text('🎬', style: TextStyle(fontSize: 48)),
      SizedBox(height: 12),
      Text('Aucun contenu', style: TextStyle(color: AppColors.textMuted,
          fontFamily: 'monospace', letterSpacing: 2, fontSize: 12)),
    ])),
  );
}