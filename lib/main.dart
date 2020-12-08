import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wifiscan/app/routes/app_routes.dart';

void main() {
  var theme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[300],
  );

  var app = GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: theme,
    getPages: AppPages.pages,
    initialRoute: Routes.HOME,
  );

  runApp(app);
}

//gerar apk-realese.apk
// flutter build apk