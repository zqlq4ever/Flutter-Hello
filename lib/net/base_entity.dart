import 'package:hello_flutter/generated/json/base/json_convert_content.dart';
import 'package:hello_flutter/res/constant.dart';

class BaseEntity<T> {
  ///  返回码
  int? code;

  ///  数据
  T? data;

  ///  附带信息
  late String message;

  BaseEntity(this.code, this.message, this.data);

  BaseEntity.fromJson(Map<String, dynamic> json) {
    code = json[AppConstant.code] as int?;
    message = json[AppConstant.message] as String;
    if (json.containsKey(AppConstant.data)) {
      data = _generateOBJ<T>(json[AppConstant.data] as Object);
    }
  }

  T _generateOBJ<O>(Object json) {
    if (T.toString() == 'String') {
      return json.toString() as T;
    } else if (T.toString() == 'Map<dynamic, dynamic>') {
      return json as T;
    } else {
      /// List 类型数据由 fromJsonAsT 判断处理
      return JsonConvert.fromJsonAsT<T>(json);
    }
  }
}
