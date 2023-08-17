import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guide_wizard/constants/dimens.dart';
import 'package:guide_wizard/constants/lang_keys.dart';
import 'package:guide_wizard/stores/technical_name/technical_name_with_translations_store.dart';
import 'package:provider/provider.dart';

class LoadImageWithCache extends StatefulWidget {
  String imageUrl;
  Color color;
  LoadImageWithCache({Key? key, required this.imageUrl, required this.color}) : super(key: key);

  @override
  State<LoadImageWithCache> createState() => _LoadImageWithCacheState();
}

class _LoadImageWithCacheState extends State<LoadImageWithCache> with SingleTickerProviderStateMixin{
  // stores:--------------------------------------------------------------------
  late TechnicalNameWithTranslationsStore _technicalNameWithTranslationsStore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // initializing stores
    _technicalNameWithTranslationsStore = Provider.of<TechnicalNameWithTranslationsStore>(context);
  }

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      url: widget.imageUrl,
      fit: BoxFit.cover,
      fadeInDuration: const Duration(milliseconds: 500),
      errorBuilder: (context, exception, stacktrace) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.sentiment_dissatisfied_outlined, size: 80, color: widget.color),
            SizedBox(height: 5,),
            Text(
              _technicalNameWithTranslationsStore.getTranslationByTechnicalName(LangKeys.could_not_load),
              style: TextStyle(fontSize: Dimens.imageCouldntLoadFontSize, color: widget.color),)
          ],
        );
      },
      loadingBuilder: (context, progress) {
        return Center(
          child: Container(
            height: 120,
            width: double.infinity,
            child: Center(
              child: Container(
                width: Dimens.imageLoadingIndicatorSize["width"],
                height: Dimens.imageLoadingIndicatorSize["height"],
                child: SizedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 4.5,
                    color: widget.color,
                    // value: progress.progressPercentage.value // Can use it to show the actual process of downloading
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
