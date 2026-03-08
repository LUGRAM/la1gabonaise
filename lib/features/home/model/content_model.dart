enum ContentType { film, serie, documentaire, concert, live }

class CastMember {
  final String name;
  final String role;
  final String emoji;
  const CastMember({required this.name, required this.role, this.emoji = '👤'});
}

class ContentModel {
  final int id;
  final String title;
  final String? thumbnailUrl;
  final String? localAsset;
  final String? bannerUrl;
  final String? localBanner;
  final String? description;
  final String? synopsis;          // texte long
  final ContentType type;
  final double rating;
  final int? year;
  final String? duration;
  final bool isGabonese;
  final bool isLive;
  final bool isExclusive;
  final String emoji;
  final int? progressPercent;
  final List<String> genres;
  final String? director;
  final List<CastMember> cast;
  final int? seasons;              // pour les séries
  final int? episodes;

  const ContentModel({
    required this.id,
    required this.title,
    this.thumbnailUrl,
    this.localAsset,
    this.bannerUrl,
    this.localBanner,
    this.description,
    this.synopsis,
    required this.type,
    this.rating = 0,
    this.year,
    this.duration,
    this.isGabonese = false,
    this.isLive = false,
    this.isExclusive = false,
    this.emoji = '🎬',
    this.progressPercent,
    this.genres = const [],
    this.director,
    this.cast = const [],
    this.seasons,
    this.episodes,
  });

  String? get bestThumbnail => thumbnailUrl ?? localAsset;
  String? get bestBanner    => bannerUrl ?? localBanner;
  bool get hasImage         => bestThumbnail != null;
  bool get hasBanner        => bestBanner != null;
  bool get isNetworkThumbnail => thumbnailUrl != null;
  bool get isNetworkBanner    => bannerUrl != null;

  String get typeLabel => switch (type) {
    ContentType.film         => 'Film',
    ContentType.serie        => 'Série',
    ContentType.documentaire => 'Doc',
    ContentType.concert      => 'Concert',
    ContentType.live         => 'LIVE',
  };

  String get heroTag => 'content_${id}_thumb';
  String get heroBannerTag => 'content_${id}_banner';

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
    id:           json['id'] as int,
    title:        json['title'] as String,
    thumbnailUrl: json['thumbnail_url'] as String?,
    bannerUrl:    json['banner_url'] as String?,
    description:  json['description'] as String?,
    synopsis:     json['synopsis'] as String?,
    type:         ContentType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => ContentType.film),
    rating:       (json['rating'] as num?)?.toDouble() ?? 0,
    year:         json['year'] as int?,
    duration:     json['duration'] as String?,
    isGabonese:   json['is_gabonese'] as bool? ?? false,
    isLive:       json['is_live'] as bool? ?? false,
    isExclusive:  json['is_exclusive'] as bool? ?? false,
    emoji:        json['emoji'] as String? ?? '🎬',
    genres:       (json['genres'] as List<dynamic>?)?.cast<String>() ?? [],
    director:     json['director'] as String?,
    seasons:      json['seasons'] as int?,
    episodes:     json['episodes'] as int?,
  );
}