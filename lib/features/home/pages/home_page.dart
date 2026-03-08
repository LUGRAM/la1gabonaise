import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import '../widget/content_card.dart';
import '../widget/home_hero.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/l1_bottom_nav.dart';
import '../../../app/widgets/app_shimmer.dart';
import '../../../app/routes/app_routes.dart';
import '../model/data/home_mock.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Contenu scrollable ──────────────────────
          Obx(() => controller.isLoadingContent.value
              ? const _LoadingState()
              : RefreshIndicator(
            onRefresh: controller.refresh,
            color: AppColors.primary,
            backgroundColor: AppColors.surfaceVar,
            child: CustomScrollView(
              slivers: [
                // Hero banner
                SliverToBoxAdapter(
                  child: HomeHero(
                    content: controller.heroContent.value,
                    onPlay: () => Get.toNamed(AppRoutes.contentDetail, arguments: controller.heroContent.value),
                    onAdd: () {},
                  ),
                ),

                // Catégories
                SliverToBoxAdapter(
                  child: _CategoriesRow(
                    categories: controller.categories,
                    active: controller.activeCategory.value,
                    onTap: controller.setCategory,
                  ),
                ),

                // Continue à regarder
                if (controller.continueWatching.isNotEmpty)
                  SliverToBoxAdapter(child: _ContentRow(
                    emoji: '▶️', title: 'Continuer à regarder',
                    items: controller.continueWatching,
                    landscape: false,
                  )),

                // Tendances
                SliverToBoxAdapter(child: _ContentRow(
                  emoji: '🔥', title: 'Tendances au Gabon',
                  items: controller.trending,
                  showRank: true,
                  onSeeAll: () => Get.toNamed(AppRoutes.catalogue, arguments: {
                    'title': 'Tendances au Gabon',
                    'items': kTrending,
                  }),
                )),

                // Live
                if (controller.liveEvents.isNotEmpty)
                  SliverToBoxAdapter(child: _ContentRow(
                    emoji: '🔴', title: 'En direct maintenant',
                    items: controller.liveEvents,
                    landscape: true,
                  )),

                // Films gabonais
                SliverToBoxAdapter(child: _ContentRow(
                  emoji: '🎬', title: 'Films gabonais',
                  items: controller.gabonFilms,
                )),

                // Espace bottom nav
                const SliverToBoxAdapter(child: SizedBox(height: 90)),
              ],
            ),
          )),

          // ── Top bar fixe ─────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 20, right: 20, bottom: 12,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1A0003), Colors.transparent],
                ),
              ),
              child: Row(children: [
                RichText(text: const TextSpan(children: [
                  TextSpan(text: 'LA', style: TextStyle(fontFamily: 'Playfair', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
                  TextSpan(text: '1', style: TextStyle(fontFamily: 'Playfair', fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2)),
                  TextSpan(text: 'GABONAISE', style: TextStyle(fontFamily: 'Playfair', fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2)),
                ])),
                const Spacer(),
                IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24), onPressed: () => Get.toNamed(AppRoutes.notifications)),
                IconButton(icon: const Icon(Icons.search, color: Colors.white, size: 24), onPressed: () => Get.toNamed(AppRoutes.search)),
              ]),
            ),
          ),

          // ── Bottom Nav ───────────────────────────────
          const Positioned(bottom: 0, left: 0, right: 0,
              child: L1BottomNav(currentIndex: 0)),
        ],
      ),
    );
  }
}

// Catégories scroll horizontal
class _CategoriesRow extends StatelessWidget {
  final List<String> categories;
  final String active;
  final void Function(String) onTap;
  const _CategoriesRow({required this.categories, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final cat = categories[i];
          final isActive = cat == active;
          return GestureDetector(
            onTap: () => onTap(cat),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.surfaceVar,
                borderRadius: BorderRadius.circular(20),
                border: isActive ? null : Border.all(color: AppColors.border),
              ),
              child: Text(cat, style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : AppColors.textMuted,
              )),
            ),
          );
        },
      ),
    );
  }
}

// Row de contenus avec titre
class _ContentRow extends StatelessWidget {
  final String emoji;
  final String title;
  final List items;
  final bool landscape;
  final bool showRank;
  final VoidCallback? onSeeAll;
  const _ContentRow({required this.emoji, required this.title, required this.items, this.landscape = false, this.showRank = false, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(children: [
            Text(emoji),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: AppTextStyles.h2)),
            GestureDetector(
              onTap: onSeeAll,
              child: const Text('Voir tout', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
            ),
          ]),
        ),
        SizedBox(
          height: landscape ? 170 : 195,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) => landscape
                ? ContentCardLandscape(
                content: items[i],
                onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: items[i]))
                : ContentCardPortrait(
                content: items[i],
                rank: showRank ? i + 1 : null,
                onTap: () => Get.toNamed(AppRoutes.contentDetail, arguments: items[i])),
          ),
        ),
      ],
    );
  }
}

// Shimmer state pendant le chargement
class _LoadingState extends StatelessWidget {
  const _LoadingState();
  @override
  Widget build(BuildContext context) {
    return const Column(children: [
      const AppShimmer(width: double.infinity, height: 340, radius: 0),
      const SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(children: [
          AppShimmerCard(width: 110, height: 155),
          const SizedBox(width: 12),
          AppShimmerCard(width: 110, height: 155),
          const SizedBox(width: 12),
          AppShimmerCard(width: 110, height: 155),
        ]),
      ),
    ]);
  }
}