import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';

class CarouselSliderPlaceHolderWidget extends StatelessWidget {
  const CarouselSliderPlaceHolderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: Dimens.homeScreen.placeHolderCarouselSliderContainerPadding,
      height: MediaQuery.of(context).size.height /
          Dimens.homeScreen.placeHolderCarouselSliderHeightRatio,
      child: CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return Container(
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width,
          margin: Dimens.stepSlider.sliderContainerMargin,
          padding: Dimens.stepSlider.sliderContainerPadding,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
                Radius.circular(Dimens.homeScreen.placeHolderStepSliderBorderRadius)),
          ),
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height / Dimens.homeScreen.placeHolderCarouselHeightRatio,
        initialPage: 0,
        enableInfiniteScroll: false,
        autoPlay: false,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
    ),
    );
  }

  
}