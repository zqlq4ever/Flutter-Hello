class NewContactEntity {
  int? id;
  int? initiator;
  int? recipient;
  String? text;
  String? remarks;
  int? checkState;
  int? showState;
  int? requestType;
  String? headPortrait;
  String? nickname;

  NewContactEntity();

  NewContactEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        initiator = json['initiator'],
        recipient = json['recipient'],
        text = json['text'],
        remarks = json['remarks'],
        checkState = json['checkState'],
        showState = json['showState'],
        requestType = json['requestType'],
        headPortrait = json['headPortrait'],
        nickname = json['nickname'];
}
