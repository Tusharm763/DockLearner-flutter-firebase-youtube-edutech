import 'package:cached_network_image/cached_network_image.dart';
import 'package:dock_learner/core/theme_set/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'data_model/user_data_model.dart';

class LoadImageFromNetwork extends StatelessWidget {
  const LoadImageFromNetwork({super.key, this.imageURL});

  final String? imageURL;

  Widget loadingBuild() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget errorBuild(BuildContext context) {
    return Center(
      child: Icon(Icons.person, color: AppTheme.primary, size: Theme
          .of(context)
          .textTheme
          .displayMedium!
          .fontSize! - 13.50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      UserData.googleUserPhotoURL,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) => (loadingProgress == null) ? child : loadingBuild(),
      errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) => errorBuild(context),
    );
  }
}

class OptimizedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OptimizedNetworkImage({super.key, required this.imageUrl, this.width, this.height, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeInCurve: Curves.easeIn,
      placeholder: (context, url) =>
          Shimmer.fromColors(
            baseColor: AppTheme.primary,
            highlightColor: AppTheme.onPrimary,
            child: Container(width: width ?? double.infinity, height: height ?? double.infinity, color: Colors.white),
          ),
      errorWidget: (context, url, error) =>
          Container(
            width: width ?? double.infinity,
            height: height ?? double.infinity,
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 40),
                const SizedBox(height: 8),
                Text('Failed to load image', style: TextStyle(color: Colors.grey[800], fontSize: 14)),
              ],
            ),
          ),
      // progressIndicatorBuilder: (context, url, downloadProgress) => Stack(
      //   alignment: Alignment.center,
      //   children: [
      //     Container(
      //       width: width ?? double.infinity,
      //       height: height ?? 200,
      //       color: Colors.grey[200],
      //     ),
      //     CircularProgressIndicator(
      //       value: downloadProgress.progress,
      //       strokeWidth: 2,
      //       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
      //     ),
      //     Text(
      //       '${(downloadProgress.progress ?? 0 * 100).toInt()}%',
      //       style: const TextStyle(
      //         color: Colors.black54,
      //         fontSize: 14,
      //         fontWeight: FontWeight.bold,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
