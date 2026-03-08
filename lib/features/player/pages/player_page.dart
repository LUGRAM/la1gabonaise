import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controller/player_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

class PlayerPage extends GetView<PlayerController> {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: controller.toggleControls,
        child: Stack(fit: StackFit.expand, children: [
          // Placeholder vidéo
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0A0520), Color(0xFF1A083A)]),
            ),
            child: const Center(child: Text('🎬', style: TextStyle(fontSize: 80))),
          ),
          // Overlay contrôles
          Obx(() => AnimatedOpacity(
            opacity: controller.showControls.value ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter, end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent, Colors.transparent, Colors.black87],
                  stops: const [0, 0.3, 0.7, 1],
                ),
              ),
              child: Column(children: [
                // Top bar
                SafeArea(child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(children: [
                    IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
                    Expanded(child: Text(controller.content.title, style: AppTextStyles.h2, overflow: TextOverflow.ellipsis)),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.cast, color: Colors.white)),
                    PopupMenuButton<String>(
                      onSelected: controller.setQuality,
                      itemBuilder: (_) => controller.qualities.map((q) => PopupMenuItem(value: q, child: Text(q))).toList(),
                      child: Obx(() => Text(controller.quality.value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700))),
                    ),
                  ]),
                )),
                const Spacer(),
                // Center controls
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(icon: const Icon(Icons.replay_10, color: Colors.white, size: 36), onPressed: () {}),
                  const SizedBox(width: 20),
                  Obx(() => GestureDetector(
                    onTap: controller.togglePlay,
                    child: Container(width: 56, height: 56,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.15), border: Border.all(color: Colors.white38)),
                      child: Icon(controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 36)),
                  )),
                  const SizedBox(width: 20),
                  IconButton(icon: const Icon(Icons.forward_10, color: Colors.white, size: 36), onPressed: () {}),
                ]),
                const Spacer(),
                // Bottom controls + progress
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                  child: Column(children: [
                    Obx(() => Slider(
                      value: controller.position.value,
                      onChanged: controller.seek,
                      activeColor: AppColors.primary,
                      inactiveColor: Colors.white24,
                      thumbColor: Colors.white,
                    )),
                    Row(children: [
                      Obx(() => Text(_formatTime(controller.position.value * controller.duration.value),
                          style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'))),
                      const Spacer(),
                      Obx(() => Text(_formatTime(controller.duration.value),
                          style: const TextStyle(color: Colors.white70, fontSize: 11, fontFamily: 'monospace'))),
                      const SizedBox(width: 12),
                      const Icon(Icons.fullscreen, color: Colors.white70, size: 22),
                    ]),
                  ]),
                ),
              ]),
            ),
          )),
        ]),
      ),
    );
  }

  String _formatTime(double seconds) {
    final d = Duration(seconds: seconds.toInt());
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}
