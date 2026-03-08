import 'package:get/get.dart';
import '../model/plan_model.dart';
import '../model/data/plans_mock.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/widgets/app_snackbar.dart';

enum PaymentMethod { airtelMoney, moovMoney, visa }

class SubscriptionController extends GetxController {
  final RxList<PlanModel> plans = <PlanModel>[].obs;
  final Rx<PlanModel?> selectedPlan = Rx<PlanModel?>(null);
  final Rx<PaymentMethod> selectedPayment = PaymentMethod.airtelMoney.obs;
  final RxBool isMonthly = true.obs;
  final RxBool isLoading = false.obs;
  final RxString phoneNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    plans.assignAll(kPlans);
    selectedPlan.value = kPlans.last; // KEVAZINGO par défaut
  }

  void selectPlan(PlanModel plan) => selectedPlan.value = plan;
  void selectPaymentMethod(PaymentMethod method) => selectedPayment.value = method;
  void toggleBilling() => isMonthly.toggle();

  int get currentPrice => isMonthly.value
      ? (selectedPlan.value?.priceMonthly ?? 0)
      : (selectedPlan.value?.priceWeekly ?? 0);

  String get priceLabel => '$currentPrice FCFA / ${isMonthly.value ? "mois" : "semaine"}';

  String get paymentMethodLabel {
    switch (selectedPayment.value) {
      case PaymentMethod.airtelMoney: return 'Airtel Money';
      case PaymentMethod.moovMoney: return 'Moov Money';
      case PaymentMethod.visa: return 'Carte bancaire';
    }
  }

  Future<void> processPayment() async {
    if (phoneNumber.value.length < 8 && selectedPayment.value != PaymentMethod.visa) {
      AppSnackbar.error('Entrez un numéro de paiement valide');
      return;
    }
    isLoading.value = true;
    try {
      // Simulation paiement (remplacer par CinetPay SDK)
      await Future.delayed(const Duration(seconds: 2));
      // TODO: _service.subscribe(plan: selectedPlan.value!, ...)
      Get.offNamed(AppRoutes.paymentSuccess);
    } catch (e) {
      AppSnackbar.error('Paiement échoué. Réessayez.');
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePhone(String? v) {
    if (v == null || v.isEmpty) return 'Numéro requis';
    if (v.length < 8) return 'Numéro invalide';
    return null;
  }
}
