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
      titleSpacing: 0,
      actions: [
        // TextButton.icon(
        //   onPressed: (){}, icon: Icon(Icons.done_rounded, color: Colors.white,), label: Text("Done"),
        // ),

      ],
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
          TextButton(
              onPressed: (){},
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
          ),
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40),),
                      color: Colors.white
                    ),
                    child: ListView(
                      controller: scrollController,
                      children: [
                        for(int i=0; i<10; i++)
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
