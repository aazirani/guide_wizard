import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate/widgets/image_slide.dart';

class BlockPageWithImage extends StatefulWidget {

  bool isDone=false;
  BlockPageWithImage({Key? key}) : super(key: key);

  @override
  State<BlockPageWithImage> createState() => _BlockPageWithImageState();
}

class _BlockPageWithImageState extends State<BlockPageWithImage> {


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
                              contentPadding: Dimens.listTilePadding,
                              dense: false,
                              horizontalTitleGap: 0.0,
                              minLeadingWidth: 0,
                              child: ExpansionTile(
                                // tilePadding: Dimens.listTilePadding,
                                textColor: AppColors.main_color,
                                iconColor: AppColors.main_color,
                                initiallyExpanded: false,
                                title: Text("Title"),
                                // controlAffinity: ListTileControlAffinity.leading,

                                children: <Widget>[
                                  Row(
                                    children: [
                                      SizedBox(width: 20,),
                                      Flexible(
                                        child: Container(
                                          width: 10,
                                          height: 300,
                                          // height: double.infinity,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Container(
                                        width: 10,
                                        height: 300,
                                        // height: double.infinity,
                                        color: Colors.transparent,
                                      ),
                                      Text("test"),
                                    ],
                                  )
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
