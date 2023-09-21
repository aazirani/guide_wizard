import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/colors.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';
import 'package:guide_wizard/widgets/measure_size.dart';
import 'package:guide_wizard/widgets/questions_list_page_appBar.dart';

class InfoDialog extends StatefulWidget {

  Widget content, bottomRow;
  double maxChildSize;

  InfoDialog({
    Key? key,
    required this.content,
    required this.bottomRow,
    this.maxChildSize = 0.75
  }) : super(key: key);

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  double widgetHeight = 0;

  Widget MakeDismissible({required Widget child}){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:  _calculateDialogContainerHeight(),
      child: MakeDismissible(
        child: DraggableScrollableSheet(
          maxChildSize: 1,
          initialChildSize: 1,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
                color: context.lightBackgroundColor,
                borderRadius: Dimens.taskPage.textOnlyScaffoldBorder,
            ),
            child: SafeArea(
              child: Stack(
                fit: StackFit.loose,
                children: [
                  ListView(
                    controller: controller,
                    children: [
                      MeasureSize(
                        child: widget.content,
                        onChange: (Size size) {
                          setState(() {
                            widgetHeight = size.height;
                          });
                        },
                      ),
                    ],
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: widget.bottomRow,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _calculateDialogContainerHeight() {
    return math.min(widgetHeight +  MediaQuery.of(context).padding.bottom, MediaQuery.of(context).size.height - QuestionsListAppBar().preferredSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom);
  }
}