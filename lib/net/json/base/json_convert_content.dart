import 'package:hello_flutter/models/contact_list/contact_list_item_entity.dart';

class JsonConvert<T> {
  T fromJson(Map<String, dynamic> json) {
    return _getFromJson<T>(runtimeType, this, json);
  }

  Map<String, dynamic> toJson() {
    return _getToJson<T>(runtimeType, this);
  }

  static _getFromJson<T>(Type type, data, json) {
    switch (type) {
      case ContactListItemEntity:
        return data as T;
    }
  }

  static _getToJson<T>(Type type, data) {
    switch (type) {
      // case ContactListItemEntity:
      //   return cityEntityToJson(data as ContactListItemEntity);
    }
    return data as T;
  }

  //Go back to a single instance by type
  static _fromJsonSingle<M>(json) {
    String type = M.toString();
    if (type == (ContactListItemEntity).toString()) {
      return ContactListItemEntity.fromJson(json);
    }
    return null;
  }

  //list is returned by type
  static M _getListChildType<M>(List data) {
    if (<ContactListItemEntity>[] is M) {
      return data.map<ContactListItemEntity>((e) => ContactListItemEntity.fromJson(e)).toList()
          as M;
    }
    throw Exception("not fond");
  }

  static M fromJsonAsT<M>(json) {
    if (json is List) {
      return _getListChildType<M>(json);
    } else {
      return _fromJsonSingle<M>(json) as M;
    }
  }
}
