import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../home/model/content_model.dart';

class PlayerController extends GetxController {
  late ContentModel content;
  VideoPlayerController? videoController;

  final RxBool isPlaying = false.obs;
  final RxBool showControls = true.obs;
  final RxBool isFullscreen = false.obs;
  final RxDouble position = 0.0.obs;
  final RxDouble duration = 1.0.obs;
  final RxString quality = 'Auto'.obs;

  final qualities = ['Auto', '1080p', '720p', '480p', '240p'];

  @override
  void onInit() {
    super.onInit();
    content = Get.arguments as ContentModel? ?? const ContentModel(id: 0, title: 'Test', type: ContentType.film);
    // TODO: initialiser VideoPlayerController avec l'URL HLS
    // videoController = VideoPlayerController.networkUrl(Uri.parse(content.streamUrl!))
    //   ..initialize().then((_) { videoController!.play(); isPlaying.value = true; });
  }

  void togglePlay() {
    isPlaying.toggle();
    // videoController?.value.isPlaying == true ? videoController?.pause() : videoController?.play();
  }

  void toggleControls() => showControls.toggle();

  void seek(double value) {
    position.value = value;
    // videoController?.seekTo(Duration(seconds: (value * duration.value).toInt()));
  }

  void setQuality(String q) => quality.value = q;

  @override
  void onClose() {
    videoController?.dispose();
    super.onClose();
  }
}
