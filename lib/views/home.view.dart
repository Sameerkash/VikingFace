import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vikings_stream/views/edit.view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

const Color primaryColor = Color(0xFF055799);
const Color secondaryColor = Color(0xFF07c6f9);

class _HomeViewState extends State<HomeView> {
  File image;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource) async {
    final pickedFile = await picker.getImage(source: imageSource);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: ScreenUtil.defaultSize.height,
          maxWidth: ScreenUtil.defaultSize.width),
      child: Scaffold(
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
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    AutoSizeText(
                      "Now, anyone can become a",
                      minFontSize: 18,
                      style: GoogleFonts.bangers(color: Colors.white),
                    ),
                    AutoSizeText(
                      "Flutter Viking!!",
                      minFontSize: 50,
                      style: GoogleFonts.bangers(color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Image.asset('assets/dash2.png'),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  child: Image.asset('assets/dash1.png'),
                ),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),

              // if (image != null)
              //   Container(
              //     height: 400,
              //     width: 350,
              //     child: Image.file(image),
              //   ),
              AutoSizeText(
                "Choose your weapon!",
                minFontSize: 18,
                style: GoogleFonts.bangers(color: Colors.white),
              ),
              SizedBox(
                height: ScreenUtil().setHeight(10),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                    ),
                    child: Icon(Icons.image),
                    onPressed: () async {
                      await getImage(ImageSource.gallery);

                      if (image != null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditView(
                              file: image,
                            ),
                          ),
                        );
                    },
                  ),
                  RaisedButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                    ),
                    child: Icon(Icons.camera),
                    onPressed: () async {
                      await getImage(ImageSource.camera);

                      if (image != null)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditView(
                              file: image,
                            ),
                          ),
                        );
                    },
                  ),
                ],
              ),
              if (image != null)
                InkWell(
                  onTap: () {
                    setState(() {
                      image = null;
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 100,
                        width: 80,
                        child: Image.file(image),
                      ),
                      Container(
                        height: 100,
                        width: 80,
                        color: Colors.black.withOpacity(0.4),
                        child: Icon(Icons.delete_forever),
                      )
                    ],
                  ),
                ),
              if (image != null)
                RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.arrow_forward_ios),
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditView(
                          file: image,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
