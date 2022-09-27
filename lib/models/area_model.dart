class AreaModel {
  static const aUid = "uid", aCode = "areaCode", aName = "areaName";

  String? uid, areaCode, areaName;

  AreaModel({
    this.uid,
    this.areaCode,
    this.areaName,
  });

  factory AreaModel.fromMap(Map<String, dynamic> map) {
    return AreaModel(
      uid: map[aUid],
      areaCode: map[aCode],
      areaName: map[aName],
    );
  }

  Map<String, dynamic> toMap() => {
        aUid: uid,
        aCode: areaCode,
        aName: areaName,
      };
}
