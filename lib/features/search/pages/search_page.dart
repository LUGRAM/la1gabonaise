import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/search_controller.dart';
import '../../home/widget/content_card.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/l1_bottom_nav.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _ctrl = Get.find<L1SearchController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const L1BottomNav(currentIndex: 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Barre de recherche ──────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: TextField(
                controller: _ctrl.searchCtrl,
                onChanged: _ctrl.onQueryChanged,
                autofocus: false,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Chercher un film, une série...',
                  prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                  suffixIcon: Obx(() => _ctrl.query.value.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textMuted, size: 18),
                    onPressed: _ctrl.clear,
                  )
                      : const SizedBox.shrink()),
                  filled: true,
                  fillColor: AppColors.surfaceVar,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                ),
              ),
            ),

            // ── Filtres ──────────────────────────────────
            SizedBox(
              height: 36,
              child: Obx(() {
                final active = _ctrl.activeFilter.value;
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _ctrl.filters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final f = _ctrl.filters[i];
                    final isActive = f == active;
                    return GestureDetector(
                      onTap: () => _ctrl.setFilter(f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.primary : AppColors.surfaceVar,
                          borderRadius: BorderRadius.circular(20),
                          border: isActive ? null : Border.all(color: AppColors.border),
                        ),
                        child: Text(f,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isActive ? Colors.white : AppColors.textMuted,
                            )),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 12),

            // ── Résultats ────────────────────────────────
            Expanded(
              child: Obx(() {
                if (_ctrl.query.value.isEmpty) {
                  return _emptyState();
                }
                if (_ctrl.isSearching.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  );
                }
                if (_ctrl.results.isEmpty) {
                  return _noResults(_ctrl.query.value);
                }
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.55,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: _ctrl.results.length,
                  itemBuilder: (_, i) => ContentCardPortrait(content: _ctrl.results[i]),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🔍', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        const Text('Recherchez un film, une série...', style: AppTextStyles.body2),
        const SizedBox(height: 8),
        Wrap(spacing: 8, children: [
          _chip('Films gabonais'),
          _chip('Séries'),
          _chip('Live'),
          _chip('Documentaires'),
        ]),
      ]),
    );
  }

  Widget _noResults(String q) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('😔', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text('Aucun résultat pour "$q"', style: AppTextStyles.body2),
        const SizedBox(height: 8),
        const Text('Essayez un autre mot-clé', style: AppTextStyles.body2),
      ]),
    );
  }

  Widget _chip(String label) {
    return GestureDetector(
      onTap: () {
        _ctrl.searchCtrl.text = label;
        _ctrl.onQueryChanged(label);
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceVar,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
      ),
    );
  }
}