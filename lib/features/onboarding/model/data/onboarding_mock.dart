class OnboardingSlide {
  final String emoji;
  final String eyebrow;
  final String title;
  final String description;
  final List<String> chips;
  final int colorSeed; // pour la couleur de fond

  const OnboardingSlide({
    required this.emoji,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.chips,
    required this.colorSeed,
  });
}

const kOnboardingSlides = [
  OnboardingSlide(
    emoji: '🎬',
    eyebrow: 'Bienvenue',
    title: 'Le streaming\n100% gabonais',
    description: 'Films, séries et documentaires produits au Gabon et en Afrique centrale. Votre culture, votre écran.',
    chips: ['🇬🇦 Gabon', '🎬 100% local', '📱 Mobile'],
    colorSeed: 0,
  ),
  OnboardingSlide(
    emoji: '📺',
    eyebrow: 'Exclusivités',
    title: 'Séries africaines\nen exclusivité mondiale',
    description: 'Productions originales, mini-séries, feuilletons — tournés au Gabon, au Cameroun, au Congo. Du jamais-vu sur aucune autre plateforme.',
    chips: ['🎬 Originaux', '🌍 Afrique centrale', '⭐ Exclusif'],
    colorSeed: 1,
  ),
  OnboardingSlide(
    emoji: '🎥',
    eyebrow: 'Créateurs',
    title: 'Soutenez les\ntalents gabonais',
    description: 'Cinéastes indépendants, influenceurs, réalisateurs locaux. Vos vues financent directement leur création.',
    chips: ['💰 Revenus directs', '⭐ Badge certifié', '🤝 Communauté'],
    colorSeed: 2,
  ),
  OnboardingSlide(
    emoji: '📶',
    eyebrow: 'Sans limite',
    title: 'Téléchargez &\nregardez sans connexion',
    description: 'Adapté au réseau gabonais. Qualité automatique selon votre connexion 2G/3G/4G.',
    chips: ['📱 Mode offline', '📶 2G/3G/4G', '💾 Téléchargement'],
    colorSeed: 3,
  ),
];
