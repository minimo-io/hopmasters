import 'package:Hops/theme/style.dart';
import 'package:flutter/material.dart';

class LoadNetworkImage extends StatelessWidget {
  final String? uri;
  final double? height;
  LoadNetworkImage({ this.uri, this.height });

  @override
  Widget build(BuildContext context) {
    return Image.network( this.uri!,
      height: this.height,
      fit: BoxFit.fill,
      loadingBuilder:(BuildContext context, Widget child,ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: PROGRESS_INDICATOR_COLOR,
            value: loadingProgress.expectedTotalBytes != null ?
            loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}
