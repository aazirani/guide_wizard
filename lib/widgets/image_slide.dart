import 'package:boilerplate/constants/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlide extends StatefulWidget {

  List<String?> images;
  String description;
  ImageSlide({Key? key, required this.images, required this.description}) : super(key: key);

  @override
  State<ImageSlide> createState() => _ImageSlideState();
}

class _ImageSlideState extends State<ImageSlide> {

  int _slideIndex = 0;
  late List<Image> _imagesList;

  @override
  void initState() {
    super.initState();
    _imagesList = widget.images.map((e) => Image.network(e!, fit: BoxFit.fitHeight,),).toList();
  }

  @override
  Widget build(BuildContext context) {

    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
        children: [
          Flexible(
            child: CarouselSlider(
              options: CarouselOptions(
                height: screenHeight / 3,
                viewportFraction: 1,
                autoPlay: true,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) =>
                    setState(() => _slideIndex = index),
              ),
              items: _imagesList,
            ),
          ),
          SizedBox(height: 15,),
          Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35,),
                  child: Text(
                    widget.description,
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: _slideIndex,
                    count: _imagesList.length,
                    textDirection: TextDirection.ltr,
                    effect: ScrollingDotsEffect(
                      activeDotColor: AppColors.bright_foreground_color,
                      dotColor: AppColors.bright_foreground_color.withOpacity(0.7),
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
          ),
        ]
    );
  }
}
