import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guide_wizard/data/network/constants/endpoints.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:guide_wizard/widgets/load_image_with_cache.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:guide_wizard/constants/colors.dart';

class ImageSlide extends StatefulWidget {
  List<String?> images;
  String description;
  ImageSlide({Key? key, required this.images, required this.description})
      : super(key: key);

  @override
  State<ImageSlide> createState() => _ImageSlideState();
}

class _ImageSlideState extends State<ImageSlide> {
  int _slideIndex = 0;
  late List<LoadImageWithCache> _imagesList;

  @override
  void initState() {
    super.initState();
    _imagesList = widget.images
        .map(
          (e) => LoadImageWithCache(
            imageUrl: Endpoints.tasksImageBaseUrl + e!,
            color: AppColors.grey50,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: screenHeight / 2.7,
            viewportFraction: 1,
            autoPlay: true,
            autoPlayInterval: Duration(milliseconds: 6000),
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) =>
                setState(() => _slideIndex = index),
          ),
          items: _imagesList,
        ),
        widget.images.length <= 1
            ? SizedBox()
            : Positioned.fill(
                bottom: 35,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedSmoothIndicator(
                    activeIndex: _slideIndex,
                    count: _imagesList.length,
                    textDirection: TextDirection.ltr,
                    effect: ScrollingDotsEffect(
                      activeDotColor: context.lightBackgroundColor,
                      dotColor: context.dotColor,
                      activeStrokeWidth: 2.6,
                      activeDotScale: 1.3,
                      maxVisibleDots: 5,
                      radius: 8,
                      spacing: 10,
                      dotHeight: 12,
                      dotWidth: 12,
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
