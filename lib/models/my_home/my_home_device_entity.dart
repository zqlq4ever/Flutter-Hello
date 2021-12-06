import 'dart:convert';

class MyHomeDeviceBean {
  int id;
  String? deviceCode;
  String? name;
  String? deviceNickname;
  int? deviceState;
  int? startState;
  String? lastHeartBeat;
  int? bindingState;
  String? batteryState;
  int? networking;
  String? versionNumber;
  String? simPhone;
  int isDfDevice;

  MyHomeDeviceBean(this.id, this.isDfDevice, this.deviceNickname);

  @override
  String toString() {
    return jsonEncode(this);
  }
}
