enum DownloadStatus { pending, downloading, completed, failed, paused }

class DownloadModel {
  final int id;
  final String contentId;
  final String title;
  final String? subtitle;
  final String emoji;
  final DownloadStatus status;
  final double progress;
  final int fileSizeMb;
  final String quality;
  final DateTime downloadedAt;
  final int durationMinutes;
  final String? thumbnailUrl;   // URL réseau
  final String? localAsset;     // asset local

  const DownloadModel({
    required this.id, required this.contentId, required this.title,
    this.subtitle, required this.emoji, required this.status,
    this.progress = 1.0, required this.fileSizeMb, required this.quality,
    required this.downloadedAt, required this.durationMinutes,
    this.thumbnailUrl,
    this.localAsset,
  });

  bool get isCompleted  => status == DownloadStatus.completed;
  bool get isDownloading => status == DownloadStatus.downloading;
  String get sizeLabel   => '$fileSizeMb MB';
  String get durationLabel {
    final h = durationMinutes ~/ 60;
    final m = durationMinutes % 60;
    return h > 0 ? '${h}h${m.toString().padLeft(2,'0')}' : '${m}min';
  }
}