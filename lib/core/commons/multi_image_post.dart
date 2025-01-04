import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiImagePost extends ConsumerStatefulWidget {
  final List<String> imagesList;
  const MultiImagePost({super.key,required this.imagesList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MultiImagePostState();
}

class _MultiImagePostState extends ConsumerState<MultiImagePost> {
  int activePage = 0;
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    return LayoutBuilder(
     builder: (context, constraints) {
        return Stack(
        children: [
          CarouselSlider.builder(
            itemCount: widget.imagesList.length,
            itemBuilder: (context, index, realIndex) {
              final image = widget.imagesList[index];
              return Container(
                width: double.infinity,
                height: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              height: constraints.maxHeight,
              aspectRatio: constraints.maxWidth / constraints.maxHeight,
              enableInfiniteScroll: false,
              viewportFraction: 1.1,
              enlargeCenterPage: false,
              onPageChanged: (index,reason){
                setState(() {
                  activePage = index;
                });
              }
            ),
          ),
        if(widget.imagesList.length != 1)
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSmoothIndicator(
              activeIndex: activePage,
              count: widget.imagesList.length,
              effect: ExpandingDotsEffect(
                dotWidth: 10,
                dotHeight: 10,
                activeDotColor: theme == ThemeMode.dark
                    ? Pallete.appColorDark
                    : Pallete.appColorLight,
              ),
            ),
          )
        ],
      );
     }
    );
  }
}