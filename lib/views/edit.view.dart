import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../utils/dialog.dart';
import 'home.view.dart';

class EditView extends StatefulWidget {
  final File file;

  const EditView({Key key, this.file}) : super(key: key);

  @override
  _EditViewState createState() => _EditViewState();
}

class _EditViewState extends State<EditView> {
  File filter;
  String caption;
  int xCoordinate;

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  List<String> filters = [
    "f1.png",
    "f2.png",
    "f3.png",
    "f4.png",
    "f5.png",
    "f6.png",
    "f7.png",
    "f8.png",
  ];

  List<String> captions = [
    "#Flutter Vikings",
    "Plundering for Flutter Gems",
    "I am now a Viking!!",
    "Battle Me!!",
    "I Love Dash!!",
  ];

  List<int> x = [250, 100, 200, 300, 250];

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

    // final josesans = await FontUtility().getFile();

    img.copyInto(mergedImage, img1, blend: true);
    img.copyInto(mergedImage, image2, blend: true);

    if (caption != null)
      img.drawString(mergedImage, img.arial_48, xCoordinate, 1020, caption,
          color: img.getColor(0, 150, 255));

    final directory = await getExternalStorageDirectory();
    final myImagePath = '${directory.path}/viking';

    final myImgDir = await new Directory(myImagePath).create();

    final file =
        new File(join(myImgDir.path, "viking${random.nextDouble()}.jpg"));
    file.writeAsBytesSync(img.encodeJpg(mergedImage));

    // AlbumSaver.saveToAlbum(filePath: file.path, albumName: "Viking Face");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Choose a filter!",
          style: GoogleFonts.bangers(color: Colors.white),
        ),
        actions: [
          FlatButton(
            onPressed: () async {
              showBlockingDialog(context);
              await saveImage();
              Navigator.pop(context);

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
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          colors: [
            primaryColor,
            secondaryColor,
          ],
          // stops: [
          //   0.8,
          //   0.2,
          // ],
        )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: ScreenUtil().setHeight(500),
              width: ScreenUtil().setWidth(400),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.file(
                      widget.file,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  if (filter != null)
                    Container(
                      child: Image.file(
                        filter,
                        height: ScreenUtil().setHeight(500),
                        width: ScreenUtil().setWidth(400),
                        fit: BoxFit.contain,
                      ),
                    ),
                  if (caption != null)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        height: 45,
                        child: AutoSizeText(
                          caption,
                          maxLines: 1,
                          minFontSize: 26,
                          maxFontSize: 28,
                          style: GoogleFonts.josefinSans(color: Colors.blue),
                        ),
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            Container(
              height: ScreenUtil().setHeight(30),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: captions.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        caption = captions[index];
                        xCoordinate = x[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      height: 10,
                      color: Colors.white,
                      child: Text(
                        captions[index],
                        style: GoogleFonts.josefinSans(color: Colors.blue),
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) {
                  return SizedBox(
                    width: 5,
                  );
                },
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        setImageFilter(index);
                      },
                      child: Container(
                        color: Colors.white,
                        height: 60,
                        width: 60,
                        child: Image.asset("assets/${filters[index]}"),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) {
                    return SizedBox(
                      width: 10,
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
