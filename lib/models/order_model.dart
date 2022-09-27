import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  static const oUID = "uId",
      prodCode = "pCode",
      prodName = "pName",
      pOrderQuantity = "pOrderQuantity",
      pBonus = "bonus",
      pExtra = "extra",
      pNet = "net",
      pRemarks = "remarks",
      oOrderBy = "orderBy",
      oDateTime = "orderDateTime";

  String? uId, pCode, pName, orderQuantity, bonus, extra, net, remarks, orderBy;
  Timestamp? productAdditionDateTime;

  OrderModel(
      {this.uId,
      this.pCode,
      this.pName,
      this.orderQuantity,
      this.bonus,
      this.extra,
      this.net,
      this.remarks,
      this.orderBy,
      this.productAdditionDateTime});

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
        //uId: map[oUID],
        bonus: map[pBonus],
        extra: map[pExtra],
        productAdditionDateTime: map[oDateTime],
        pCode: map[prodCode],
        pName: map[prodName],
        orderBy: map[oOrderBy],
        orderQuantity: map[pOrderQuantity],
        remarks: map[pRemarks],
        net: map[pNet]);
  }

  Map<String, dynamic> toMap() => {
        //oUID: uId,
        prodName: pName,
        prodCode: pCode,
        pOrderQuantity: orderQuantity,
        oDateTime: productAdditionDateTime,
        pBonus: bonus,
        oOrderBy: orderBy,
        pExtra: extra,
        pNet: net,
        pRemarks: remarks
      };

}
