import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/ui/blocks/sub_block_widget.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/widgets/blocks_appbar_widget.dart';
import 'package:boilerplate/widgets/image_slide.dart';
import 'package:boilerplate/widgets/measure_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:boilerplate/models/block/sub_block.dart';

List<SubBlockModel> subBlocks = [
  SubBlockModel(
    title: "Title",
  ),
  SubBlockModel(
    title: "Title",
  ),
  SubBlockModel(
    title: "Title",
  ),
];

class BlockPageWithImage extends StatefulWidget {
  bool isDone = false;
  BlockPageWithImage({Key? key}) : super(key: key);

  @override
  State<BlockPageWithImage> createState() => _BlockPageWithImageState();
}

class _BlockPageWithImageState extends State<BlockPageWithImage> {
  RenderParametersManager renderManager = RenderParametersManager<dynamic>();


  var appBarSize = Size.zero, imageSlideSize = Size.zero;

  @override
  void initState() {
    super.initState();
  }

  double _getHeightOfDraggableScrollableSheet(){
    double screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight - (appBarSize.height + imageSlideSize.height)) / screenHeight;
  }

  Widget _buildDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: _getHeightOfDraggableScrollableSheet(),
        minChildSize: _getHeightOfDraggableScrollableSheet(),
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            color: AppColors.main_color,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: AppColors.bright_foreground_color),
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: scrollController,
                  itemCount: subBlocks.length,
                  itemBuilder: (context, i) {
                    return SubBlock(
                      index: i,
                      subBlockModelsList: subBlocks,
                      renderManager: renderManager,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageSlide() {
    return ImageSlide(images: []);
  }

  Widget _buildScaffoldBody() {
    return Stack(
      children: [
        MeasureSize(
            onChange: (Size size) {
              setState(() {
                imageSlideSize = size;
              });
            },
            child: _buildImageSlide()),
        _buildDraggableScrollableSheet(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: MeasureSize(
        onChange: (Size size) {
          setState(() {
            appBarSize = size;
          });
        },
        child: BlocksAppBarWidget(
          isDone: widget.isDone, //TODO isDone must be fixed with adding STORES
        ),
      ) as PreferredSizeWidget?,
      body: _buildScaffoldBody(),
    );
  }
}
