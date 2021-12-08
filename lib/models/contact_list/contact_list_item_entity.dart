// {
//     "id": 460048897474560,
//     "userId": 460048142499840,
//     "contactName": "本机用户",
//     "contactPhone": "18668248373",
//     "contactPhoto": "http://adkx.net/wzxze",
//     "sex": 0,
//     "birthdate": "2020-10",
//     "faceIdentificationState": 0,
//     "appstate": 2,
//     "type": 1,  0:其它 1:家人
//     "standbyState1": 1
//   },
class ContactListItemEntity {
  int id;
  int userId;
  String? contactName;
  String? contactPhone;
  String? contactPhoto;
  int? sex;
  String? birthdate;
  int? faceIdentificationState;
  int appstate;
  int? type;
  int? standbyState1;

  // 命名构造函数
  ContactListItemEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['userId'],
        contactName = json['contactName'],
        contactPhone = json['contactPhone'],
        contactPhoto = json['contactPhoto'],
        sex = json['sex'],
        birthdate = json['birthdate'],
        faceIdentificationState = json['faceIdentificationState'],
        appstate = json['appstate'],
        type = json['type'],
        standbyState1 = json['standbyState1'];
}
