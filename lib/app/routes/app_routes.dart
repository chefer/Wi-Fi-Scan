import 'package:get/get.dart';
import 'package:wifiscan/app/ui/pages/home/home_page.dart';
import 'package:wifiscan/app/ui/pages/server/server_page.dart';

// rotas do app
abstract class Routes {
  static const HOME = '/home';
  static const SERVER = '/server';
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => HomePage(),
    ),
    GetPage(
      name: Routes.SERVER,
      page: () => ServerPage(),
    ),
  ];
}
