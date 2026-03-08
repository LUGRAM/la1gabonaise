import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../home/model/content_model.dart';
import '../../home/model/data/home_mock.dart';

class L1SearchController extends GetxController {
  final TextEditingController searchCtrl = TextEditingController();
  final RxString query = ''.obs;
  final RxList<ContentModel> results = <ContentModel>[].obs;
  final RxBool isSearching = false.obs;
  final RxString activeFilter = 'Tout'.obs;

  final allContent = [...kTrending, ...kGabonFilms, ...kLiveEvents];
  final filters = ['Tout', 'Films', 'Séries', 'Docs', '🇬🇦 Gabon'];

  @override
  void onInit() {
    super.onInit();
    debounce(query, _search, time: const Duration(milliseconds: 400));
  }

  void onQueryChanged(String v) => query.value = v;

  void setFilter(String f) {
    activeFilter.value = f;
    _search(query.value);
  }

  Future<void> _search(String q) async {
    if (q.isEmpty) { results.clear(); return; }
    isSearching.value = true;
    await Future.delayed(const Duration(milliseconds: 200));
    var filtered = allContent.where((c) => c.title.toLowerCase().contains(q.toLowerCase())).toList();
    if (activeFilter.value == 'Films') filtered = filtered.where((c) => c.type == ContentType.film).toList();
    if (activeFilter.value == 'Séries') filtered = filtered.where((c) => c.type == ContentType.serie).toList();
    if (activeFilter.value == '🇬🇦 Gabon') filtered = filtered.where((c) => c.isGabonese).toList();
    results.assignAll(filtered);
    isSearching.value = false;
  }

  void clear() { searchCtrl.clear(); query.value = ''; results.clear(); }

  @override
  void onClose() { searchCtrl.dispose(); super.onClose(); }
}