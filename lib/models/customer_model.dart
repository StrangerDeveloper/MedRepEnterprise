import 'dart:convert';

class CustomerModel {
  static const cUid = "uid",
      cCode = "code",
      cName = "name",
      cAddress = "address",
      cAreaCode = "areaCode",
      cAreaName = "areaName";

  String? uid, code, name, address, areaCode, areaName;

  CustomerModel(
      {this.uid,
      this.code,
      this.name,
      this.address,
      this.areaCode,
      this.areaName});

  CustomerModel.fromList(List item)
      : this(
            uid: "",
            code: "${item[0]}",
            name: "${item[1]}",
            address: "${item[2]}",
            areaCode: "${item[3]}",
            areaName: "${item[4]}");

  factory CustomerModel.fromDoc(Object? data) {
    Map<String, dynamic> map = data as Map<String, dynamic>;
    return CustomerModel.fromMap(map);
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
        uid: map[cUid],
        areaCode: map[cAreaCode],
        areaName: map[cAreaName],
        name: map[cName],
        code: map[cCode],
        address: map[cAddress]);
  }

  Map<String, dynamic> toMap() => {
        cUid: uid,
        cCode: code,
        cName: name,
        cAreaName: areaName,
        cAddress: address,
        cAreaCode: areaCode,
      };



  static String encode(List<CustomerModel> customers) => json.encode(
        customers
            .map<Map<String, dynamic>>((customer) => customer.toMap())
            .toList(),
      );

  static List<CustomerModel> decode(String customers) =>
      (json.decode(customers) as List<dynamic>)
          .map<CustomerModel>((item) => CustomerModel.fromMap(item))
          .toList();
}
