import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'views/home.view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LayoutBuilder(builder: (context, constrains) {
        final size = MediaQuery.of(context).size;

        ScreenUtil.init(
          context,
          allowFontScaling: true,
          designSize: Size(size.width, size.height),
        );
        return HomeView();
      }),
    );
  }
}
