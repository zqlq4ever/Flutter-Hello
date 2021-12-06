import 'dart:convert';

class SettingMenuBean {
  String title;
  String? name;
  String? photo;

  SettingMenuBean(this.title);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
