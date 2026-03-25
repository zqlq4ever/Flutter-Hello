import 'package:get/get.dart';
import 'package:hello_flutter/page/account/page/account_home_page.dart';
import 'package:hello_flutter/page/account/page/update_password_page.dart';
import 'package:hello_flutter/page/contact/page/contact_detail_page.dart';
import 'package:hello_flutter/page/contact/page/contact_history_page.dart';
import 'package:hello_flutter/page/contact/page/contact_list_page.dart';
import 'package:hello_flutter/page/contact/page/newcontact_page.dart';
import 'package:hello_flutter/page/data/page/data_chart_page.dart';
import 'package:hello_flutter/page/data/page/data_detail_page.dart';
import 'package:hello_flutter/page/data/page/data_home_page.dart';
import 'package:hello_flutter/page/data/page/data_single_page.dart';
import 'package:hello_flutter/page/data/page/measure_notice_page.dart';
import 'package:hello_flutter/page/home/page/home_page.dart';
import 'package:hello_flutter/page/login/page/complete_person_info_page.dart';
import 'package:hello_flutter/page/login/page/default_header_page.dart';
import 'package:hello_flutter/page/login/page/forget_password_page.dart';
import 'package:hello_flutter/page/login/page/login_page.dart';
import 'package:hello_flutter/page/login/page/register_page.dart';
import 'package:hello_flutter/page/myhome/page/my_home_page.dart';
import 'package:hello_flutter/page/myhome/page/qr_code_scanner_page.dart';
import 'package:hello_flutter/page/setting/page/about_page.dart';
import 'package:hello_flutter/page/setting/page/feedback_page.dart';
import 'package:hello_flutter/page/setting/page/setting_page.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    // 登录相关
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.forgetPassword,
      page: () => const ForgetPasswordPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.completeInfo,
      page: () => const CompletePersonInfoPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.defaultHeader,
      page: () => const DefautHeaderPage(),
      transition: Transition.rightToLeft,
    ),

    // 主页
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),

    // 我的主页
    GetPage(
      name: AppRoutes.myHome,
      page: () => const MyHomePage(),
      transition: Transition.rightToLeft,
    ),

    // 数据相关
    GetPage(
      name: AppRoutes.dataHome,
      page: () => const DataHomePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dataDetail,
      page: () => const DataDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dataChart,
      page: () => const DataChartPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.dataSingle,
      page: () => const DataSinglePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.measureNotice,
      page: () => const MeasureNoticePage(),
      transition: Transition.rightToLeft,
    ),

    // 联系人相关
    GetPage(
      name: AppRoutes.contactList,
      page: () => const ContactListPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.contactDetail,
      page: () => const ContactDetailPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.contactHistory,
      page: () => const ContactHistoryPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.newContact,
      page: () => const NewContactPage(),
      transition: Transition.rightToLeft,
    ),

    // 设置相关
    GetPage(
      name: AppRoutes.setting,
      page: () => const SettingPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.feedback,
      page: () => const FeedbackPage(),
      transition: Transition.rightToLeft,
    ),

    // 账户相关
    GetPage(
      name: AppRoutes.accountHome,
      page: () => const AccountHomePage(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.updatePassword,
      page: () => const UpdatePasswordPage(),
      transition: Transition.rightToLeft,
    ),

    // 扫码
    GetPage(
      name: AppRoutes.qrCodeScanner,
      page: () => const QrCodeScannerPage(),
      transition: Transition.rightToLeft,
    ),
  ];
}
