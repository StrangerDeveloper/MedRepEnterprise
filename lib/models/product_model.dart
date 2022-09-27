class ProductModel {
  static const pCode = "productCode",
      pName = "productName",
      cName = "companyName",
      cCode = "companyCode",
      cFileName = "csvFileName";

  String? productName, companyName, csvFileName, productCode, companyCode;
  bool? isAddedToList;
  //int? productCode, companyCode;

  ProductModel({
    this.companyCode,
    this.productCode,
    this.companyName,
    this.productName,
    this.csvFileName,
    this.isAddedToList = false,
  });


  ProductModel.fromList(List item)
      : this(
            productCode: "${item[0]}",
            productName: "${item[1]}",
            companyCode: "${item[2]}",
            companyName: "${item[3]}");

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
        productCode: map[pCode],
        productName: map[pName],
        companyCode: map[cCode],
        companyName: map[cName],
        csvFileName: map[cFileName]);
  }

  Map<String, dynamic> toMap() => {
        pCode: productCode,
        pName: productName,
        cCode: companyCode,
        cName: companyName,
        cFileName: csvFileName
      };
}
