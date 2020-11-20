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

  List<String> filters = ["viking.png", "f1.png"];

  void setImageFilter(index) async {
    filter = await getImageFileFromAssets(filters[index]);
    setState(() {});

    print(filter);
  }

  Random random = Random();

  Future<void> saveImage() async {
    final image1 = img.decodeImage(widget.file.readAsBytesSync());
    final image2 = img.decodeImage(filter.readAsBytesSync());
    final mergedImage = img.Image(800, 1100);

    final img1 = img.copyResize(image1, height: 1100, width: 800);
    // final img2intern = img.copyRotate(img1, 90);

    img.copyInto(mergedImage, img1, blend: true);
    img.copyInto(mergedImage, image2, blend: true);

    // final image = img.copyRotate(mergedImage, 90);

    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory.path}/viking';

    final myImgDir = await new Directory(myImagePath).create();

    // double rand = img.crand(random);

    final file = new File(join(myImgDir.path, "viking3.jpg"));
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
            height: 550,
            width: 400,
            child: Stack(children: [
              Image.file(widget.file),
              if (filter != null)
                Container(
                  child: Image.file(
                    filter,
                    height: 550,
                    width: 400,
                    fit: BoxFit.contain,
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
              itemCount: filters.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () {
                    setImageFilter(index);
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    child: Image.asset("assets/${filters[index]}"),
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
