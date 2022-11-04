import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/widgets/image_slide.dart';

class BlockPageWithImage extends StatefulWidget {
  const BlockPageWithImage({Key? key}) : super(key: key);

  @override
  State<BlockPageWithImage> createState() => _BlockPageWithImageState();
}

class _BlockPageWithImageState extends State<BlockPageWithImage> {

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: Dimens.appBar["titleSpacing"],
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/icons/appbar_logo.png',
            fit: BoxFit.cover,
            height: Dimens.appBar["logoHeight"],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: ImageSlide(images: []),
              ),
            ],
          ),
          SizedBox.expand(
            child: DraggableScrollableSheet(
              snap: true,
              initialChildSize: 0.55,
              minChildSize: 0.55,
              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  color: AppColors.main_color,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40),),
                      color: Colors.white
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Image.asset('assets/images/img_no_jobs.png'),
                        ),
                      ]
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
