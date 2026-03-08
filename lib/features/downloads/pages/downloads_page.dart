import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/downloads_controller.dart';
import '../model/download_model.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/widgets/l1_bottom_nav.dart';
import '../../../app/routes/app_routes.dart';

class DownloadsPage extends GetView<DownloadsController> {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      bottomNavigationBar: const L1BottomNav(currentIndex: 2),
      body: SafeArea(
        child: Obx(() {
          final hasDownloads = controller.downloads.isNotEmpty;
          return CustomScrollView(
            slivers: [
              // ── Header ──────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('TÉLÉCHARGEMENTS', style: AppTextStyles.labelRed),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: Text('Hors ligne', style: AppTextStyles.display3)),
                      if (hasDownloads)
                        GestureDetector(
                          onTap: () => _confirmClearAll(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.primaryGlow,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                            ),
                            child: const Text('Tout supprimer',
                                style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)),
                          ),
                        ),
                    ]),

                    // Barre stockage
                    if (hasDownloads) ...[
                      const SizedBox(height: 14),
                      _StorageBar(controller: controller),
                    ],
                  ]),
                ),
              ),

              if (!hasDownloads)
                SliverFillRemaining(child: _EmptyState())
              else ...[
                // ── En cours ────────────────────────────────
                if (controller.inProgress.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _sectionTitle('⏳', 'En cours')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _DownloadTile(
                        item: controller.inProgress[i],
                        onDelete: () => controller.delete(controller.inProgress[i].id),
                        onToggle: () => controller.togglePause(controller.inProgress[i]),
                      ),
                      childCount: controller.inProgress.length,
                    ),
                  ),
                ],

                // ── Complétés ───────────────────────────────
                if (controller.completed.isNotEmpty) ...[
                  SliverToBoxAdapter(child: _sectionTitle('✅', 'Prêts à regarder')),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => _DownloadTile(
                        item: controller.completed[i],
                        onDelete: () => controller.delete(controller.completed[i].id),
                        onPlay: () => Get.toNamed(AppRoutes.player),
                      ),
                      childCount: controller.completed.length,
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ],
          );
        }),
      ),
    );
  }

  Widget _sectionTitle(String emoji, String label) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
    child: Row(children: [
      Text(emoji),
      const SizedBox(width: 8),
      Text(label, style: AppTextStyles.h2),
    ]),
  );

  void _confirmClearAll(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppColors.surfaceVar,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 20),
          const Text('🗑️', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 12),
          const Text('Supprimer tous les téléchargements ?', style: AppTextStyles.h2, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          const Text('Cette action est irréversible.', style: AppTextStyles.body2, textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.border)),
              child: const Text('Annuler', style: TextStyle(color: AppColors.textMuted)),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () { Get.back(); Get.find<DownloadsController>().clearAll(); },
              child: const Text('Supprimer'),
            )),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ── Tile téléchargement ─────────────────────────────────
class _DownloadTile extends StatelessWidget {
  final DownloadModel item;
  final VoidCallback onDelete;
  final VoidCallback? onPlay;
  final VoidCallback? onToggle;

  const _DownloadTile({required this.item, required this.onDelete, this.onPlay, this.onToggle});

  @override
  Widget build(BuildContext context) {
    final isInProgress = item.status == DownloadStatus.downloading || item.status == DownloadStatus.paused;

    return Dismissible(
      key: Key('dl_${item.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.error.withOpacity(0.15),
        child: const Icon(Icons.delete_outline, color: AppColors.error, size: 24),
      ),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: item.isCompleted ? onPlay : onToggle,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceVar,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(children: [
            // Thumbnail emoji
            Container(
              width: 56, height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.surface, AppColors.surfaceHigh],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.title, style: AppTextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(item.subtitle ?? '', style: AppTextStyles.bodySmall),
              const SizedBox(height: 6),
              Row(children: [
                _tag(item.quality, AppColors.info.withOpacity(0.15), AppColors.info),
                const SizedBox(width: 6),
                _tag(item.durationLabel, AppColors.surfaceHigh, AppColors.textMuted),
                const SizedBox(width: 6),
                _tag(item.sizeLabel, AppColors.surfaceHigh, AppColors.textMuted),
              ]),

              // Progress bar si en cours
              if (isInProgress) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: item.progress,
                    backgroundColor: AppColors.border,
                    color: item.status == DownloadStatus.paused ? AppColors.warning : AppColors.primary,
                    minHeight: 3,
                  ),
                ),
                const SizedBox(height: 4),
                Row(children: [
                  Text('${(item.progress * 100).toInt()}%',
                    style: const TextStyle(fontSize: 10, color: AppColors.primary, fontFamily: 'monospace')),
                  const Spacer(),
                  Text(item.status == DownloadStatus.paused ? 'En pause' : 'Téléchargement...',
                    style: const TextStyle(fontSize: 10, color: AppColors.textMuted, fontFamily: 'monospace')),
                ]),
              ],
            ])),

            // Action button
            const SizedBox(width: 8),
            if (item.isCompleted)
              Container(
                width: 36, height: 36,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.play_arrow_rounded, color: Colors.black, size: 20),
              )
            else
              Icon(
                item.status == DownloadStatus.paused ? Icons.play_circle_outline : Icons.pause_circle_outline,
                color: AppColors.textMuted, size: 28,
              ),
          ]),
        ),
      ),
    );
  }

  Widget _tag(String label, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
    child: Text(label, style: TextStyle(fontSize: 9, color: fg, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
  );
}

// ── Barre stockage ─────────────────────────────────────
class _StorageBar extends StatelessWidget {
  final DownloadsController controller;
  const _StorageBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final pct = (controller.totalSizeMb / 4096).clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVar,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Row(children: [
          const Icon(Icons.storage_outlined, color: AppColors.textMuted, size: 16),
          const SizedBox(width: 8),
          const Expanded(child: Text('Stockage utilisé', style: AppTextStyles.bodySmall)),
          Text(controller.totalSizeLabel,
            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700)),
          const Text(' / 4 GB', style: AppTextStyles.bodySmall),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: pct, minHeight: 4,
            backgroundColor: AppColors.border,
            color: pct > 0.8 ? AppColors.warning : AppColors.primary,
          ),
        ),
      ]),
    );
  }
}

// ── Empty State ────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 96, height: 96,
          decoration: BoxDecoration(
            color: AppColors.primaryGlow,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: const Center(child: Text('📥', style: TextStyle(fontSize: 44))),
        ),
        const SizedBox(height: 20),
        const Text('Aucun téléchargement', style: AppTextStyles.h2),
        const SizedBox(height: 8),
        const Text('Téléchargez des films et séries\npour les regarder sans connexion.',
          style: AppTextStyles.body2, textAlign: TextAlign.center),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          onPressed: () => Get.offNamed('/home'),
          icon: const Icon(Icons.explore_outlined, size: 18),
          label: const Text('Explorer le catalogue'),
        ),
      ]),
    );
  }
}
