import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/widgets/image_slide.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:widget_size/widget_size.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:boilerplate/widgets/measure_size.dart';

class BlockPageWithImage extends StatefulWidget {

  bool isDone=false;
  BlockPageWithImage({Key? key}) : super(key: key);

  @override
  State<BlockPageWithImage> createState() => _BlockPageWithImageState();
}

class _BlockPageWithImageState extends State<BlockPageWithImage> {

  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  double expansion_child_size = 0;


  Widget _buildDoneButton(){
    return TextButton(
      onPressed: (){
        setState(() {
          widget.isDone = !widget.isDone;
        });
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all<Color>(Colors.white10),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.button_background_color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
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


  Widget _buildUndoneButton(){
    return TextButton(
      onPressed: (){
        setState(() {
          widget.isDone = !widget.isDone;
        });
      },
      style: ButtonStyle(
          overlayColor: MaterialStateProperty.all<Color>(Colors.white10),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
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

  Widget _buildAppBarButton(){
    return widget.isDone ? _buildUndoneButton():_buildDoneButton();
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: 0,
      leading: IconButton(
          onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white,),
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
  }


  double _getHeightByRenderID(String ID){
    RenderData? data = renderManager.getRenderData(ID);
    return data==null ? 0 : data.height;
  }

  Widget _getExpansionContent(){

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, right: 15,),
          child: DottedLine(
            dashLength: 15,
            dashGapLength: 15,
            lineThickness: 7,
            dashColor: Colors.green,
            direction: Axis.vertical,
            lineLength: _getHeightByRenderID("ExpandedBlockID"),
            // lineLength: expansion_child_size,
          ),
        ),
        // Flexible(
        //   child: MeasureSize(
        //     onChange: (Size size) {
        //       setState(() {
        //         expansion_child_size=size as double;
        //       });
        //     },
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 5),
        //       child: Text(
        //         "test " * 120,
        //         // overflow: TextOverflow.clip,
        //       ),
        //     ),
        //   ),
        // ),
        Flexible(
          child: RenderMetricsObject(
            id: "ExpandedBlockID",
            manager: renderManager,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "test " * 120,
                // overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
      ],
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
                      color: Colors.white
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: ListView(
                        shrinkWrap: true,
                        controller: scrollController,
                        children: [
                          for(int i=0; i<10; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                // side: BorderSide(color: AppColors.main_color)
                            ),
                            child: ListTileTheme(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(color: AppColors.main_color, width: 2),
                              ),
                              tileColor: AppColors.button_background_color,
                              textColor: AppColors.main_color,
                              contentPadding: Dimens.listTilePadding,
                              dense: false,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ExpansionTile(
                                onExpansionChanged: ((isNewState){
                                  // if(isNewState){
                                  //   setState(() {});
                                  // }
                                }),
                                textColor: AppColors.main_color,
                                iconColor: AppColors.main_color,
                                initiallyExpanded: false,
                                title: Text("Title",),
                                children: <Widget>[
                                  _getExpansionContent(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                        ]
                      ),
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
