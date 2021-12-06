import 'package:hello_flutter/res/constant.dart';

import 'json/base/json_convert_content.dart';

class BaseEntity<T> {
  BaseEntity(this.code, this.message, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[AppConstant.code] as int?;
    message = json[AppConstant.message] as String;
    if (json.containsKey(AppConstant.data)) {
      data = _generateOBJ<T>(json[AppConstant.data] as Object);
    }
  }

  int? code;
  late String message;
  T? data;

  T _generateOBJ<O>(Object json) {
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// List类型数据由fromJsonAsT判断处理
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}
