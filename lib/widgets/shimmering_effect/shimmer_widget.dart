import 'package:flutter/material.dart';
import 'package:guide_wizard/widgets/shimmering_effect/shimmer_list_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:guide_wizard/utils/extension/context_extensions.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.shimmerBaseColor,
      highlightColor: context.shimmerHeighlightColor,
      child: ShimmerListWidget(),
    );
  }
}