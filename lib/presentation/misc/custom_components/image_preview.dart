import 'package:flutter/material.dart';
import '../../../../core/enum.dart';
import 'custom_elements.dart';

class ImagePreviewPopupAlt extends StatefulWidget {
  final String imageUrl;
  final ImageType? imageType;

  const ImagePreviewPopupAlt(
      {Key? key, required this.imageUrl, this.imageType = ImageType.link})
      : super(key: key);

  @override
  _ImagePreviewPopupAltState createState() => _ImagePreviewPopupAltState();
}

class _ImagePreviewPopupAltState extends State<ImagePreviewPopupAlt> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.cancel, color: Colors.white)),
            ),
            const SizedBox(height: 5),
            widget.imageType == ImageType.link
                ? loadNetworkImage(widget.imageUrl, height: 450, borderRadius: BorderRadius.circular(0))
                : Image.asset(widget.imageUrl, height: 450),
          ],
        ),
      ),
    );
  }
}
