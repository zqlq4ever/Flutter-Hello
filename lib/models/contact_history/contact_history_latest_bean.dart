class ContactHistoryLatestBean {
  int? udId;
  String? contactName;
  String? createTime;
  String? contactPhoto;
  String? phone;

  ContactHistoryLatestBean();

  ContactHistoryLatestBean.fromJson(Map<String, dynamic> json)
      : udId = json['udId'],
        contactName = json['contactName'],
        createTime = json['createTime'],
        contactPhoto = json['contactPhoto'],
        phone = json['phone'];
}
