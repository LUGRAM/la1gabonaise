import '../download_model.dart';

final kMockDownloads = [
  DownloadModel(id: 1, contentId: 'c22', title: 'Libreville Nuit Noire',
    subtitle: 'Film · 2024', emoji: '🌆', status: DownloadStatus.completed,
    fileSizeMb: 847, quality: '1080p', durationMinutes: 108,
    downloadedAt: DateTime.now().subtract(const Duration(hours: 2))),
  DownloadModel(id: 2, contentId: 'c3', title: 'Ogooué',
    subtitle: 'Série · S1 É3', emoji: '🌊', status: DownloadStatus.completed,
    fileSizeMb: 312, quality: '720p', durationMinutes: 45,
    downloadedAt: DateTime.now().subtract(const Duration(days: 1))),
  DownloadModel(id: 3, contentId: 'c20', title: 'Masques de Fang',
    subtitle: 'Film · 2024', emoji: '🎭', status: DownloadStatus.downloading,
    progress: 0.67, fileSizeMb: 920, quality: '4K', durationMinutes: 118,
    downloadedAt: DateTime.now()),
  DownloadModel(id: 4, contentId: 'c4', title: 'La Forêt Sacrée',
    subtitle: 'Documentaire · 52min', emoji: '🌿', status: DownloadStatus.paused,
    progress: 0.3, fileSizeMb: 420, quality: '1080p', durationMinutes: 52,
    downloadedAt: DateTime.now().subtract(const Duration(hours: 5))),
];
