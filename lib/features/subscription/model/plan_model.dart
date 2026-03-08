class PlanModel {
  final String id;
  final String name;
  final int priceMonthly;
  final int priceWeekly;
  final List<String> features;
  final bool isPopular;
  final int maxProfiles;
  final String quality;

  const PlanModel({
    required this.id,
    required this.name,
    required this.priceMonthly,
    required this.priceWeekly,
    required this.features,
    this.isPopular = false,
    required this.maxProfiles,
    required this.quality,
  });
}
