import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:hello_flutter/page/login/page/login_page.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
    ),
  ];
}
