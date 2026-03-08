import '../content_model.dart';

const _baseUnsplash = 'https://images.unsplash.com';

const kHeroContent = ContentModel(
  id: 1,
  title: 'La Bataille des Camps',
  description: 'Un thriller gabonais haletant dans les rues de Libreville.',
  synopsis:
  'Dans les bas-fonds de Libreville, deux clans rivaux se disputent le contrôle '
      'du marché de Mont-Bouët. Kévin, jeune flic infiltré, se retrouve tiraillé '
      'entre son devoir et les liens du sang. Entre corruption, trahisons et honneur, '
      'il devra choisir son camp — ou périr entre les deux.\n\n'
      'Un film sombre et sans concession qui plonge au cœur des tensions sociales '
      'du Gabon contemporain.',
  type: ContentType.film,
  rating: 8.7, year: 2024, duration: '1h 48m',
  isGabonese: true, isExclusive: true, emoji: '🎬',
  bannerUrl: '$_baseUnsplash/photo-1489599849927-2ee91cede3ba?w=1280&q=80',
  thumbnailUrl: '$_baseUnsplash/photo-1536440136628-849c177e76a1?w=400&q=80',
  genres: ['Thriller', 'Action', 'Drame'],
  director: 'Idriss Moubamba',
  cast: [
    CastMember(name: 'Joël Ossima',   role: 'Kévin',   emoji: '🎭'),
    CastMember(name: 'Laure Nzamba',  role: 'Astrid',  emoji: '🎭'),
    CastMember(name: 'Patrick Bongo', role: 'Le Chef',  emoji: '🎭'),
    CastMember(name: 'Marie Allogho', role: 'La mère', emoji: '🎭'),
  ],
);

final kTrending = [
  const ContentModel(
    id: 2, title: 'Massanga', type: ContentType.film,
    rating: 8.2, year: 2023, emoji: '🏔️', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1518791841217-8f162f1912da?w=400&q=80',
    genres: ['Aventure'],
    description: 'Un alpiniste gabonais affronte ses démons au sommet du monde.',
  ),
  const ContentModel(
    id: 3, title: 'Ogooué', type: ContentType.serie,
    rating: 7.9, year: 2024, emoji: '🌊', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
    bannerUrl: '$_baseUnsplash/photo-1476514525535-07fb3b4ae5f1?w=800&q=80',
    genres: ['Drame', 'Nature'],
    description: 'Sur les rives du fleuve Ogooué, une famille affronte la modernité.',
    synopsis:
    'Saison 1 — La famille Mbadinga vit depuis trois générations sur les rives '
        'de l\'Ogooué. Quand une multinationale convoite leurs terres pour extraire '
        'le pétrole, le clan se fracture. L\'aîné veut résister, le cadet veut vendre, '
        'et la cadette part étudier à Libreville, emportant avec elle les secrets '
        'de la rivière sacrée.\n\n'
        'Une saga familiale poignante sur l\'identité gabonaise face à la mondialisation.',
    seasons: 2, episodes: 16,
    director: 'Nathalie Moundounga',
    cast: [
      CastMember(name: 'Serge Mbadinga',  role: 'Le Père',   emoji: '🎭'),
      CastMember(name: 'Cléa Nguema',     role: 'Élodie',    emoji: '🎭'),
      CastMember(name: 'Bertrand Ovono',  role: 'Stéphane',  emoji: '🎭'),
    ],
  ),
  const ContentModel(
    id: 4, title: 'La Forêt Sacrée', type: ContentType.documentaire,
    rating: 7.6, duration: '52min', emoji: '🌿', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1448375240586-882707db888b?w=400&q=80',
    genres: ['Documentaire', 'Nature'],
    description: 'Plongée au cœur des forêts équatoriales du Gabon.',
  ),
  const ContentModel(
    id: 5, title: 'Nzame', type: ContentType.film,
    rating: 8.4, year: 2023, emoji: '👑', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1533107862482-0e6974b06ec4?w=400&q=80',
    genres: ['Historique', 'Drame'],
    description: 'L\'épopée du premier roi Fang selon la tradition orale.',
  ),
  const ContentModel(
    id: 6, title: 'Rumba Night', type: ContentType.concert,
    rating: 8.0, emoji: '🎵', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1493225457124-a3eb161ffa5f?w=400&q=80',
    genres: ['Concert', 'Musique'],
    description: 'Un soir de rumba gabonaise filmé au cœur de Libreville.',
  ),
];

final kLiveEvents = [
  const ContentModel(
    id: 10, title: 'Gabon Music Awards', type: ContentType.live,
    isLive: true, emoji: '🎤', isGabonese: true,
    bannerUrl: '$_baseUnsplash/photo-1501386761578-eaa54522176f?w=800&q=80',
    thumbnailUrl: '$_baseUnsplash/photo-1501386761578-eaa54522176f?w=400&q=80',
  ),
  const ContentModel(
    id: 11, title: 'Panthères vs Léopards', type: ContentType.live,
    isLive: true, emoji: '⚽', isGabonese: true,
    bannerUrl: '$_baseUnsplash/photo-1508098682722-e99c43a406b2?w=800&q=80',
    thumbnailUrl: '$_baseUnsplash/photo-1508098682722-e99c43a406b2?w=400&q=80',
  ),
];

final kGabonFilms = [
  const ContentModel(
    id: 20, title: 'Masques de Fang', type: ContentType.film,
    rating: 8.0, year: 2024, emoji: '🎭', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1485846234645-a62644f84728?w=400&q=80',
    genres: ['Drame', 'Culture'],
    description: 'Un masque cérémoniel disparu réapparaît, ravivant d\'anciens conflits.',
  ),
  const ContentModel(
    id: 21, title: "L'Envol", type: ContentType.film,
    rating: 7.5, year: 2023, emoji: '🦅', isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1464822759023-fed622ff2c3b?w=400&q=80',
    genres: ['Aventure', 'Drame'],
    description: 'Un jeune pilote gabonais rêve de traverser l\'Atlantique.',
  ),
  const ContentModel(
    id: 22, title: 'Libreville Nuit Noire', type: ContentType.film,
    rating: 8.7, year: 2024, emoji: '🌆', isGabonese: true, isExclusive: true,
    thumbnailUrl: '$_baseUnsplash/photo-1519501025264-65ba15a82390?w=400&q=80',
    bannerUrl: '$_baseUnsplash/photo-1519501025264-65ba15a82390?w=800&q=80',
    genres: ['Thriller', 'Noir'],
    description: 'Une nuit, une disparition, toute une ville sous tension.',
    synopsis:
    'Une journaliste d\'investigation reçoit un message anonyme à 2h du matin. '
        'En suivant la piste, elle découvre un réseau de corruption qui remonte '
        'jusqu\'aux plus hautes sphères de Libreville. Elle n\'a que jusqu\'à l\'aube '
        'pour tout exposer — ou disparaître elle aussi.\n\n'
        'Un film noir haletant, tourné entièrement en nuit réelle dans les quartiers '
        'de Libreville.',
    director: 'Gaël Koumba',
    cast: [
      CastMember(name: 'Sylvie Nkoghe',    role: 'La journaliste', emoji: '🎭'),
      CastMember(name: 'Henri Bounguendza', role: 'Le ministre',    emoji: '🎭'),
      CastMember(name: 'Rose Ondo',         role: 'La source',      emoji: '🎭'),
    ],
  ),
];

final kContinueWatching = [
  const ContentModel(
    id: 3, title: 'Ogooué S1É3', type: ContentType.serie,
    emoji: '🌊', progressPercent: 62, isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1476514525535-07fb3b4ae5f1?w=400&q=80',
    bannerUrl: '$_baseUnsplash/photo-1476514525535-07fb3b4ae5f1?w=800&q=80',
  ),
  const ContentModel(
    id: 22, title: 'Libreville Nuit Noire', type: ContentType.film,
    emoji: '🌆', progressPercent: 38, isGabonese: true,
    thumbnailUrl: '$_baseUnsplash/photo-1519501025264-65ba15a82390?w=400&q=80',
    bannerUrl: '$_baseUnsplash/photo-1519501025264-65ba15a82390?w=800&q=80',
  ),
];


// ── Résout le contenu complet par id ────────────────────
// Utilisé par ContentDetailPage pour enrichir les entrées
// allégées (ex: kContinueWatching qui n'a pas synopsis/cast)
ContentModel resolveContent(ContentModel partial) {
  final all = [
    kHeroContent,
    ...kTrending,
    ...kLiveEvents,
    ...kGabonFilms,
  ];
  return all.firstWhere(
        (c) => c.id == partial.id,
    orElse: () => partial,
  );
}