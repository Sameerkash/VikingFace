import 'dart:io';
import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class EditView extends StatefulWidget {
  final File file;

  const EditView({Key key, this.file}) : super(key: key);

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  File filter;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  void setImageFilter(index) async {
    filter = await getImageFileFromAssets('viking.png');
    setState(() {});

    print(filter);
  }

  Future<void> saveImage() async {
    final image1 = img.decodeImage(widget.file.readAsBytesSync());
    final image2 = img.decodeImage(filter.readAsBytesSync());
    final mergedImage = img.Image(
        image1.width + image2.width, max(image1.height, image2.height));

    img.copyInto(mergedImage, image1, blend: false);
    img.copyInto(mergedImage, image2, dstX: image1.width, blend: false);

    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory.path}/viking';

    final myImgDir = await new Directory(myImagePath).create();

    final file = new File(join(myImgDir.path, "viking1.jpg"));
    file.writeAsBytesSync(img.encodeJpg(mergedImage));

    print(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          FlatButton(
            onPressed: () async {
              await saveImage();

              Flushbar(
                duration: Duration(seconds: 2),
                title: "Saved",
                message: "You're now a viking!",
              ).show(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.done,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            height: 450,
            width: 350,
            child: Stack(children: [
              Image.file(widget.file),
              if (filter != null)
                Positioned(
                  // top: 10,
                  left: 90,
                  // bottom: 20,
                  child: Container(
                    child: Image.file(
                      filter,
                      height: 170,
                      width: 180,
                    ),
                  ),
                ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    setImageFilter(index);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: Image.asset("assets/viking.png"),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
