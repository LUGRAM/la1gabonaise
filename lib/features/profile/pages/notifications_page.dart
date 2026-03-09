import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';

// ── Modèle notification ───────────────────────────────────
enum NotifType { newContent, live, payment, system, promo }

class L1Notification {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final DateTime date;
  bool isRead;
  final String? imageEmoji;

  L1Notification({
    required this.id, required this.type, required this.title,
    required this.body, required this.date,
    this.isRead = false, this.imageEmoji,
  });
}

// ── Mock données ──────────────────────────────────────────
final _mockNotifs = <L1Notification>[
  L1Notification(id: '1', type: NotifType.newContent,
      title: 'Nouveau sur LA1GABONAISE',
      body: '« Libreville Nuit Noire » est maintenant disponible. Regardez-le avant tout le monde.',
      date: DateTime.now().subtract(const Duration(minutes: 12)),
      imageEmoji: '🌆', isRead: false),
  L1Notification(id: '2', type: NotifType.live,
      title: '🔴 EN DIRECT — Gabon Music Awards',
      body: 'Le live commence dans 30 minutes. Préparez-vous pour la grande soirée.',
      date: DateTime.now().subtract(const Duration(hours: 1)),
      imageEmoji: '🎤', isRead: false),
  L1Notification(id: '3', type: NotifType.newContent,
      title: 'Ogooué — Saison 2 disponible',
      body: 'Les 8 nouveaux épisodes de la saison 2 sont en ligne. Reprenez où vous vous étiez arrêté.',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      imageEmoji: '🌊', isRead: false),
  L1Notification(id: '4', type: NotifType.payment,
      title: 'Renouvellement confirmé',
      body: 'Votre abonnement KEVAZINGO a été renouvelé avec succès pour 5 500 FCFA.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      imageEmoji: '💳', isRead: true),
  L1Notification(id: '5', type: NotifType.promo,
      title: 'Offre spéciale ce week-end 🎉',
      body: 'Partagez LA1GABONAISE avec un ami et obtenez 1 mois gratuit. Offre valable jusqu\'au dimanche.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      imageEmoji: '🎁', isRead: true),
  L1Notification(id: '6', type: NotifType.system,
      title: 'Mise à jour disponible',
      body: 'Une nouvelle version de l\'application est disponible. Mettez à jour pour profiter des dernières fonctionnalités.',
      date: DateTime.now().subtract(const Duration(days: 3)),
      imageEmoji: '⚙️', isRead: true),
  L1Notification(id: '7', type: NotifType.newContent,
      title: 'Recommandé pour vous',
      body: '« Masques de Fang » correspond à vos goûts. Un film historique gabonais à ne pas manquer.',
      date: DateTime.now().subtract(const Duration(days: 4)),
      imageEmoji: '🎭', isRead: true),
  L1Notification(id: '8', type: NotifType.live,
      title: 'Panthères vs Léopards — Ce soir',
      body: 'Match en direct à 20h00. Activez les rappels pour ne pas rater le coup d\'envoi.',
      date: DateTime.now().subtract(const Duration(days: 5)),
      imageEmoji: '⚽', isRead: true),
];

// ── Page ─────────────────────────────────────────────────
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final List<L1Notification> _notifs;
  String _filter = 'Tous';
  static const _filters = ['Tous', 'Non lus', 'Contenus', 'Live', 'Système'];

  @override
  void initState() {
    super.initState();
    _notifs = List.from(_mockNotifs);
  }

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  List<L1Notification> get _filtered {
    switch (_filter) {
      case 'Non lus':   return _notifs.where((n) => !n.isRead).toList();
      case 'Contenus':  return _notifs.where((n) => n.type == NotifType.newContent).toList();
      case 'Live':      return _notifs.where((n) => n.type == NotifType.live).toList();
      case 'Système':   return _notifs.where((n) =>
      n.type == NotifType.system || n.type == NotifType.payment || n.type == NotifType.promo).toList();
      default:          return _notifs;
    }
  }

  void _markAllRead() => setState(() { for (final n in _notifs) n.isRead = true; });
  void _markRead(L1Notification n) => setState(() => n.isRead = true);
  void _delete(L1Notification n) => setState(() => _notifs.remove(n));

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final items = _filtered;
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => Get.back(),
        ),
        title: Row(children: [
          const Text('Notifications',
              style: TextStyle(fontFamily: 'Playfair', fontSize: 18,
                  fontWeight: FontWeight.w800, color: Colors.white)),
          if (_unreadCount > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                  color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
              child: Text('$_unreadCount',
                  style: const TextStyle(fontSize: 10, color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ]),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: const Text('Tout lire',
                  style: TextStyle(fontSize: 11, color: AppColors.primary,
                      fontFamily: 'monospace')),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: SizedBox(height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final selected = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : AppColors.surfaceVar,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(f, style: TextStyle(fontSize: 11,
                        fontWeight: FontWeight.w700, fontFamily: 'monospace',
                        color: selected ? Colors.white : AppColors.textMuted)),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: items.isEmpty
          ? _emptyState()
          : ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 40),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(
            color: AppColors.borderLight, height: 1, indent: 16, endIndent: 16),
        itemBuilder: (_, i) => _NotifTile(
          notif: items[i],
          onTap: () => _markRead(items[i]),
          onDismiss: () => _delete(items[i]),
        ),
      ),
    );
  }

  Widget _emptyState() => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
    const Text('🔔', style: TextStyle(fontSize: 48)),
    const SizedBox(height: 12),
    const Text('Aucune notification', style: TextStyle(
        color: AppColors.textMuted, fontFamily: 'monospace',
        letterSpacing: 2, fontSize: 12)),
    const SizedBox(height: 6),
    Text(_filter == 'Non lus' ? 'Vous êtes à jour 👍' : 'Revenez plus tard',
        style: const TextStyle(color: AppColors.textDisabled, fontSize: 11)),
  ]));
}

// ── Tuile notification ────────────────────────────────────
class _NotifTile extends StatelessWidget {
  final L1Notification notif;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  const _NotifTile({required this.notif, required this.onTap, required this.onDismiss});

  Color get _typeColor => switch (notif.type) {
    NotifType.newContent => AppColors.primary,
    NotifType.live       => const Color(0xFFE53935),
    NotifType.payment    => AppColors.gold,
    NotifType.promo      => const Color(0xFF27AE60),
    NotifType.system     => AppColors.textMuted,
  };

  String get _typeLabel => switch (notif.type) {
    NotifType.newContent => 'NOUVEAU',
    NotifType.live       => 'LIVE',
    NotifType.payment    => 'PAIEMENT',
    NotifType.promo      => 'OFFRE',
    NotifType.system     => 'SYSTÈME',
  };

  String _formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24)   return 'Il y a ${diff.inHours}h';
    if (diff.inDays == 1)    return 'Hier';
    return 'Il y a ${diff.inDays} jours';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: notif.isRead ? Colors.transparent : AppColors.primary.withOpacity(0.04),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

            // Avatar emoji
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: AppColors.surfaceVar,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: notif.isRead ? AppColors.border : _typeColor.withOpacity(0.4)),
              ),
              child: Center(child: Text(notif.imageEmoji ?? '🔔',
                  style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),

            // Contenu
            Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                      color: _typeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(_typeLabel, style: TextStyle(fontSize: 8,
                      color: _typeColor, fontFamily: 'monospace',
                      fontWeight: FontWeight.w800)),
                ),
                const Spacer(),
                Text(_formatDate(notif.date),
                    style: const TextStyle(fontSize: 10, color: AppColors.textDisabled,
                        fontFamily: 'monospace')),
              ]),
              const SizedBox(height: 5),
              Text(notif.title, style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700,
                  color: notif.isRead ? AppColors.textPrimary : Colors.white)),
              const SizedBox(height: 3),
              Text(notif.body, style: const TextStyle(
                  fontSize: 12, color: AppColors.textMuted, height: 1.4),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ])),

            // Pastille non lu
            if (!notif.isRead)
              Container(
                width: 8, height: 8, margin: const EdgeInsets.only(left: 8, top: 4),
                decoration: const BoxDecoration(
                    color: AppColors.primary, shape: BoxShape.circle),
              ),
          ]),
        ),
      ),
    );
  }
}