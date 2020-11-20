import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vikings_stream/views/edit.view.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Become a Viking!"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(),
            if (image != null)
              Container(
                height: 400,
                width: 350,
                child: Image.file(image),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
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
          ],
        ),
      ),
    );
  }
}
