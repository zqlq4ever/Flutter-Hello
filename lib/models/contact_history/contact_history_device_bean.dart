import 'dart:convert';

class ContactHistoryDeviceBean {
  int id;
  String? deviceCode;
  String? name;
  String? deviceNickname;
  int? deviceState;
  String? simPhone;
  int isDfDevice;

  ContactHistoryDeviceBean(this.id, this.deviceNickname, this.isDfDevice);

  ContactHistoryDeviceBean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        deviceCode = json['deviceCode'],
        name = json['name'],
        deviceNickname = json['deviceNickname'],
        deviceState = json['deviceState'],
        simPhone = json['simPhone'],
        isDfDevice = json['isDfDevice'];

  @override
  String toString() {
    return jsonEncode(this);
  }
}
