import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({super.key, required this.imageUrl, this.height, this.width, this.radius});
  final String imageUrl;
  final double? height, width, radius;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(imageUrl: imageUrl,
    errorWidget: (context, url, error) => CircleAvatar(radius: 15.r, backgroundColor: Colors.amber,),
     fit: BoxFit.cover,imageBuilder: (context, imageProvider) {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius:radius?? 15.r, backgroundImage: imageProvider,foregroundImage: imageProvider,);
        
    },);
  }
}