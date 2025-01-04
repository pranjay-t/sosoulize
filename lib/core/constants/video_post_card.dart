import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPostCard extends ConsumerStatefulWidget {
  final String postVideo;
  const VideoPostCard({super.key,required this.postVideo});


  
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VideoPostCardState();
}

class _VideoPostCardState extends ConsumerState<VideoPostCard> {
  late VideoPlayerController videoController;

  void selectPostVideo() async {
    try {

      videoController = VideoPlayerController.networkUrl(Uri.parse(widget.postVideo))
          ..initialize().then((_) {
            if (mounted) {
              setState(() {});
            }
          });      

      setState(() {});
    } catch (e) {
      print('Video Displaying Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    selectPostVideo();
  }

  @override
  void dispose() {
    super.dispose();
    videoController.dispose();
  }

  void switchOnOff() {
    videoController.value.isPlaying
        ? setState(() {
            videoController.pause();
          })
        : setState(() {
            videoController.play();
          });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: videoController.value.isInitialized
          ? Stack(
              alignment: AlignmentDirectional.center,
              children: [
                FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    width: videoController.value.size.width,
                    height: videoController.value.size.height,
                    child: VideoPlayer(videoController),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: videoController.value.isPlaying
                            ? const Icon(Icons.pause)
                            : const Icon(Icons.play_arrow),
                        onPressed: () => switchOnOff(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
