import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlide extends StatefulWidget {

  List<Image> images;

  ImageSlide({Key? key, required this.images}) : super(key: key);

  @override
  State<ImageSlide> createState() => _ImageSlideState();
}

class _ImageSlideState extends State<ImageSlide> {

  int _slideIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 250,
              viewportFraction: 1,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) =>
                  setState(()=> _slideIndex=index),
            ),
            items: [1,2,3,4,5].map((i) {
              return Image.asset('assets/images/patterns.png', fit: BoxFit.fitHeight,);
            }).toList(),
          ),
          SizedBox(height: 15,),
          Stack(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: const EdgeInsets.only(left: 35,),
                  child: Text(
                    "Info",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: AnimatedSmoothIndicator(
                    // onDotClicked: (index){
                    //   setState(() {
                    //     _slideIndex=index;
                    //   });
                    // },
                    activeIndex: _slideIndex,
                    count: 5,
                    textDirection: TextDirection.ltr,
                    effect: ScrollingDotsEffect(
                      activeDotColor: Colors.white,
                      dotColor: Colors.white70,
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
