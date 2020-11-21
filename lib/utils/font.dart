import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

class FontUtility {
  FontUtility();

  // static final assetImage = Image.asset('assets/jfs.png');

  // static img.Image image =
  //     img.Image(assetImage.width.toInt(), assetImage.height.toInt());

  Future<img.BitmapFont> getFile() async {
    final im1 = await getImageFileFromAssets('jfs.png');
    final mergedImage = img.Image(256, 256);

    final interm = img.decodeImage(im1.readAsBytesSync());
    img.copyInto(mergedImage, interm);

    final jfs = img.BitmapFont.fromFnt('assets/jfs.fnt', mergedImage);

    return jfs;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}
