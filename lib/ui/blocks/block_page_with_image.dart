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

  Widget _buildDoneButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isDone = !widget.isDone;
        });
      },
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.white10),
          backgroundColor: MaterialStateProperty.all<Color>(
              AppColors.button_background_color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
              )
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3,),
            Icon(Icons.done_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }


  Widget _buildUndoneButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          widget.isDone = !widget.isDone;
        });
      },
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.white10),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: Dimens.blockPageAppBarButtonBorderRadius,
                  side: BorderSide(color: Colors.white)
              )
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Text(
              "Undone",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            SizedBox(width: 3,),
            Icon(Icons.close_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarButton() {
    return widget.isDone ? _buildUndoneButton() : _buildDoneButton();
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
      ),
      title: Row(
        children: [
          Text(
            "Private Housing",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          Spacer(),
          _buildAppBarButton(),
          SizedBox(width: 15,),
        ],
      ),
    );
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
