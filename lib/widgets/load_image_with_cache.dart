import 'package:boilerplate/constants/colors.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

class LoadImageWithCache extends StatefulWidget {
  String imageUrl;
  Color color;
  LoadImageWithCache({Key? key, required this.imageUrl, required this.color}) : super(key: key);

  @override
  State<LoadImageWithCache> createState() => _LoadImageWithCacheState();
}

class _LoadImageWithCacheState extends State<LoadImageWithCache> with SingleTickerProviderStateMixin{

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
              AppLocalizations.of(context).translate("could_not_load"),
              style: TextStyle(fontSize: 22, color: widget.color),)
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
                width: 60,
                height: 60,
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
