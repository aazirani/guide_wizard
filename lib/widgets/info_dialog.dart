import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/constants/dimens.dart';
import 'package:flutter/material.dart';

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
  Widget MakeDismissible({required Widget child}){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: GestureDetector(onTap: () {}, child: child,),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MakeDismissible(
      child: DraggableScrollableSheet(
        maxChildSize: widget.maxChildSize,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: Dimens.taskPageTextOnlyScaffoldBorder,
          ),
          child: Stack(
            fit: StackFit.loose,
            children: [
              ListView(
                controller: controller,
                children: [
                  widget.content,
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
    );
  }
}