import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:boilerplate/widgets/image_slide.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:render_metrics/render_metrics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:boilerplate/widgets/app_expansiontile.dart';

class BlockPageWithImage extends StatefulWidget {

  bool isDone=false;
  BlockPageWithImage({Key? key}) : super(key: key);
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();

  @override
  State<BlockPageWithImage> createState() => _BlockPageWithImageState();
}

class _BlockPageWithImageState extends State<BlockPageWithImage> {

  RenderParametersManager renderManager = RenderParametersManager<dynamic>();
  // double expansion_child_size = 0;

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

  Widget _buildAppBarButton() {
    return widget.isDone ? _buildUndoneButton() : _buildDoneButton();
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.main_color,
      toolbarHeight: Dimens.appBar["toolbarHeight"],
      titleSpacing: 0,
      leading: IconButton(
        onPressed: () {},
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
  }

  Widget _getExpansionContent() {
    return ExpansionContent(renderManager: renderManager);
  }

  Widget _buildExpansionTile() {
    return Padding(
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
            child: AppExpansionTile(
              onExpansionChanged: ((isNewState) {
                // if(isNewState){
                //   setState(() {});
                // }
              }),
              textColor: AppColors.main_color,
              iconColor: AppColors.main_color,
              initiallyExpanded: false,
              title: Text("Title",),
              key: widget.expansionTile,
              children: <Widget>[
                _getExpansionContent(),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildDraggableScrollableSheet() {
    return SizedBox.expand(
      child: DraggableScrollableSheet(
        snap: true,
        initialChildSize: 0.55,
        minChildSize: 0.55,
        builder: (BuildContext context,
            ScrollController scrollController) {
          return Container(
            color: AppColors.main_color,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),),
                  color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: scrollController,
                  children: [
                    _buildExpansionTile(),
                  ]
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildImageSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: ImageSlide(images: []),
    );
  }


  Widget _buildScaffoldBody() {
    return Stack(
      children: [
        _buildImageSlide(),
        _buildDraggableScrollableSheet(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main_color,
      appBar: _buildAppBar(),
      body: _buildScaffoldBody(),
    );
  }
}

class ExpansionContent extends StatefulWidget {
  const ExpansionContent({
    Key? key,
    required this.renderManager,
  }) : super(key: key);

  final RenderParametersManager renderManager;

  @override
  State<ExpansionContent> createState() => _ExpansionContentState();
}

class _ExpansionContentState extends State<ExpansionContent> {

  double widgetHeight = 0;

  @override
  Widget build(BuildContext context) {
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
            lineLength: widgetHeight,
            //lineLength: _getHeightByRenderID("ExpandedBlockID"),
          ),
        ),
        Flexible(
          child: RenderMetricsObject(
            id: "ExpandedBlockID",
            manager: widget.renderManager,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: MeasureSize(onChange: (Size size) {
                setState(() {
                  widgetHeight = size.height;
                });
              },
              child: _buildMarkdownExample()),
            ),
          ),
        ),
      ],
    );
  }

  //double _getHeightByRenderID(String ID) {
  //  RenderData? data = widget.renderManager.getRenderData(ID);
  //  return data == null ? 0 : data.height;
  //}

  Widget _buildMarkdownExample(){
    return FutureBuilder(
        future: rootBundle.loadString("assets/markdown_test.md"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Markdown(
                onTapLink: (text, url, title){
                  _launchURL(url!);
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                data: snapshot.data!
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}


typedef void OnWidgetSizeChange(Size size);

class MeasureSizeRenderObject extends RenderProxyBox {
  Size? oldSize;
  OnWidgetSizeChange onChange;

  MeasureSizeRenderObject(this.onChange);

  @override
  void performLayout() {
    super.performLayout();

    Size newSize = child!.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onChange(newSize);
    });
  }
}

class MeasureSize extends SingleChildRenderObjectWidget {
  final OnWidgetSizeChange onChange;

  const MeasureSize({
    Key? key,
    required this.onChange,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return MeasureSizeRenderObject(onChange);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant MeasureSizeRenderObject renderObject) {
    renderObject.onChange = onChange;
  }
}