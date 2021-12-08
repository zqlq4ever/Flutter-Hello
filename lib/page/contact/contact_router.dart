import 'package:common_utils/common_utils.dart';
import 'package:fluro/fluro.dart';
import 'package:hello_flutter/page/contact/page/contact_detail_page.dart';
import 'package:hello_flutter/page/contact/page/contact_list_page.dart';
import 'package:hello_flutter/page/contact/page/newcontact_page.dart';
import 'package:hello_flutter/router/core/router_provider.dart';

class ContactRouter implements IRouterProvider {
  static String contactListPage = '/contact/list';
  static String newContactPage = '/contact/new';
  static String contactDetailPage = '/contact/detail';

  @override
  void initRouter(FluroRouter router) {
    router.define(
      contactListPage,
      handler: Handler(handlerFunc: (_, __) => const ContactListPage()),
    );
    router.define(
      newContactPage,
      handler: Handler(handlerFunc: (_, __) => const NewContactPage()),
    );
    router.define(contactDetailPage,
        handler: Handler(handlerFunc: (_, Map<String, List<String>> params) {
      final bool isDevice = params['isDevice']?.first == 'true';
      final String name = params['name']?.first ?? '';
      final String icon = EncryptUtil.decodeBase64(params['icon']?.first ?? '');
      final String id = params['id']?.first ?? '';
      final String phone = params['phone']?.first ?? '';
      final String group = params['group']?.first ?? '';

      return ContactDetailPage(
        isDevice: isDevice,
        name: name,
        icon: icon,
        id: id,
        phone: phone,
        group: group,
      );
    }));
  }
}
