import '../plan_model.dart';

const kPlans = [
  PlanModel(
    id: 'moabi', name: 'MOABI',
    priceMonthly: 3500, priceWeekly: 1000,
    maxProfiles: 1, quality: '1080p HD',
    features: ['Compte unique', 'Bonne qualité · 1080p', 'Catalogue complet', 'Streaming illimité'],
    isPopular: false,
  ),
  PlanModel(
    id: 'kevazingo', name: 'KEVAZINGO',
    priceMonthly: 5500, priceWeekly: 1500,
    maxProfiles: 3, quality: '4K Ultra HD',
    features: ['Compte familial (3)', 'Meilleure qualité · 4K', 'Téléchargements illimités', 'Live Events', 'Watch Party', 'Priorité support'],
    isPopular: true,
  ),
];
