class FamilyListEntity {

  int? id;
  String? contactName;

  FamilyListEntity();

  FamilyListEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        contactName = json['contactName'];
}
