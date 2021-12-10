import 'dart:convert';

import 'package:flutter/cupertino.dart';

class SettingMenuBean {
  String title;
  String? name;
  ImageProvider? photo;

  SettingMenuBean(this.title);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
