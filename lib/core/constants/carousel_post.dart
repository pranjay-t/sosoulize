import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sosoulize/Theme/pallete.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CarouselPost extends ConsumerStatefulWidget {
  final List<XFile> postImageList;
  final List<Uint8List> webImageList;
  const CarouselPost({super.key,required this.postImageList,required this.webImageList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CarouselPostState();
}

class _CarouselPostState extends ConsumerState<CarouselPost> {

  int activePage = 0;
  @override
  Widget build(BuildContext context) {
    final theme = ref.watch(themeNotifierProvider.notifier).mode;
    
    return widget.webImageList.isNotEmpty 
    ?Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.webImageList.length,
          itemBuilder: (context, index, realIndex) {
            final image = widget.webImageList[index];
            return Container(
              width: double.infinity,
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.memory(
                image,
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 300,
            enableInfiniteScroll: false,
            viewportFraction: 1.1,
            enlargeCenterPage: true,
            onPageChanged: (index,reason){
              setState(() {
                activePage = index;
              });
            }
          ),
        ),
      if(widget.webImageList.length > 1)
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activePage,
            count: widget.webImageList.length,
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
    )
    : Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.postImageList.length,
          itemBuilder: (context, index, realIndex) {
            final image = File(widget.postImageList[index].path);
            return Container(
              width: double.infinity,
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            );
          },
          options: CarouselOptions(
            height: 300,
            enableInfiniteScroll: false,
            viewportFraction: 1.1,
            enlargeCenterPage: true,
            onPageChanged: (index,reason){
              setState(() {
                activePage = index;
              });
            }
          ),
        ),
      if(widget.postImageList.length != 1)
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedSmoothIndicator(
            activeIndex: activePage,
            count: widget.postImageList.length,
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
}
