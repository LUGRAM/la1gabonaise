import 'package:get/get.dart';
import '../model/content_model.dart';
import '../model/data/home_mock.dart';

class HomeController extends GetxController {
  final RxInt navIndex = 0.obs;
  final RxString activeCategory = 'Pour vous'.obs;
  final RxBool isLoadingContent = false.obs;

  final Rx<ContentModel> heroContent = kHeroContent.obs;
  final RxList<ContentModel> trending       = <ContentModel>[].obs;
  final RxList<ContentModel> liveEvents     = <ContentModel>[].obs;
  final RxList<ContentModel> gabonFilms     = <ContentModel>[].obs;
  final RxList<ContentModel> continueWatching = <ContentModel>[].obs;

  final categories = ['Pour vous', 'Films', 'Séries', '🇬🇦 Gabon', '🔴 Live', 'Docs'];

  @override
  void onInit() {
    super.onInit();
    _loadContent();
  }

  Future<void> _loadContent() async {
    isLoadingContent.value = true;
    // Délai simulé réseau
    await Future.delayed(const Duration(milliseconds: 800));
    trending.assignAll(kTrending);
    liveEvents.assignAll(kLiveEvents);
    gabonFilms.assignAll(kGabonFilms);
    continueWatching.assignAll(kContinueWatching);
    isLoadingContent.value = false;
    // TODO: remplacer par appel API via HomeService
  }

  void setCategory(String cat) => activeCategory.value = cat;

  void onNavTap(int index) => navIndex.value = index;

  Future<void> refresh() => _loadContent();
}
