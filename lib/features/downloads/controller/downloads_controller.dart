import 'package:get/get.dart';
import '../model/download_model.dart';
import '../model/data/downloads_mock.dart';
import '../../../app/widgets/app_snackbar.dart';

class DownloadsController extends GetxController {
  final RxList<DownloadModel> downloads = <DownloadModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString activeFilter = 'Tous'.obs;
  final filters = ['Tous', 'Films', 'Séries', 'Docs'];

  @override
  void onInit() { super.onInit(); _load(); }

  void _load() {
    isLoading.value = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      downloads.assignAll(kMockDownloads);
      isLoading.value = false;
    });
  }

  List<DownloadModel> get inProgress => downloads.where((d) =>
    d.status == DownloadStatus.downloading || d.status == DownloadStatus.paused).toList();
  List<DownloadModel> get completed  => downloads.where((d) => d.isCompleted).toList();

  int get totalSizeMb => completed.fold(0, (s, d) => s + d.fileSizeMb);
  String get totalSizeLabel {
    final mb = totalSizeMb;
    return mb >= 1024 ? '${(mb / 1024).toStringAsFixed(1)} GB' : '$mb MB';
  }

  void delete(int id) {
    downloads.removeWhere((d) => d.id == id);
    AppSnackbar.success('Supprimé');
  }

  void togglePause(DownloadModel d) =>
    AppSnackbar.info(d.isDownloading ? 'Mis en pause' : 'Repris');

  void clearAll() {
    downloads.removeWhere((d) => d.isCompleted);
    AppSnackbar.success('Téléchargements supprimés');
  }

  void setFilter(String f) => activeFilter.value = f;
}
