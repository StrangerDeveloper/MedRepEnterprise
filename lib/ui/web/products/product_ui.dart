import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/models/product_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Row(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: ResponsiveWidget.isSmallScreen(context) ? 56 : 6),
                  child: CustomText(
                    text: menuController.activeItem.value,
                    size: 24,
                    weight: FontWeight.bold,
                  )),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              /// Button row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [

                  Expanded(
                    flex: 3,
                    child: CustomContainer(
                      padding: const EdgeInsets.all(8),
                      child: FormInputFieldWithIcon(
                        controller: productController.searchController,
                        iconPrefix: Icons.search,
                        labelText: 'Search',
                        hint: "Search with Product OR Company code/name",
                        iconColor: active!,
                        autofocus: false,
                        textStyle: bodyText1,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => productController
                            .searchInAllProducts(value.toLowerCase()),
                        onSaved: (value) => {},
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                  CustomButton(
                    onTap: () => showAddProductDialog(context),
                    text: "Add Product",
                    width: 120,
                    height: 45,
                    color: dark!,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomButton(
                    onTap: () => productController.importCsvFromStorage(),
                    text: "Import csv",
                    width: 120,
                    height: 45,
                    color: active!,
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CustomDataTable(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

void showAddProductDialog(context) {
  productController.clearControllers();
  Get.defaultDialog(
      title: "Add Product",
      titleStyle: headline3,
      content: _addProductContents(),
      backgroundColor: Colors.white);
}

Widget _addProductContents({ProductModel? productModel}) {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var error = false.obs;

  return Container(
    width: 320,
    height: 350,
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FormInputFieldWithIcon(
              controller: productController.prodCodeController,
              iconPrefix: Icons.code,
              labelText: 'Product Code',
              hint: "Code e.g. 101,102,103",
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().notEmpty,
              keyboardType: TextInputType.number,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 15,
            ),
            FormInputFieldWithIcon(
              controller: productController.prodNameController,
              iconPrefix: Icons.person,
              labelText: 'Product Name',
              hint: "Product name",
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().name,
              keyboardType: TextInputType.text,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 15,
            ),
            FormInputFieldWithIcon(
              controller: productController.compCodeController,
              iconPrefix: Icons.code,
              labelText: 'Company Code',
              hint: "Company Code e.g. 1,2,3",
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().notEmpty,
              keyboardType: TextInputType.number,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 15,
            ),
            FormInputFieldWithIcon(
              controller: productController.compNameController,
              iconPrefix: Icons.business,
              labelText: 'Company Name',
              hint: "Company Name",
              iconColor: active!.withOpacity(0.85),
              autofocus: false,
              validator: Validator().name,
              keyboardType: TextInputType.text,
              onChanged: (value) => {},
              onSaved: (value) => {},
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () => error.isTrue
                  ? Text(
                      "*Some Required are missing!",
                      style: caption.copyWith(color: colorRed!),
                    )
                  : const Text(""),
            ),
            const SizedBox(
              height: 5,
            ),
            CustomButton(
              onTap: () async {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                if (formKey.currentState!.validate()) {
                  if (productModel != null) {
                    productModel.productCode =
                        productController.prodCodeController.text;
                    productModel.productName =
                        productController.prodNameController.text;
                    productModel.companyCode =
                        productController.compCodeController.text;
                    productModel.companyName =
                        productController.compNameController.text;

                    await productController.updateProductById(productModel);
                  } else {
                    await productController.createProduct();
                  }
                  error.value = false;
                  Get.back();
                } else {
                  error.value = true;
                }
              },
              text: productModel != null ? "Update" : "Submit",
              width: 150,
              height: 40,
              color: productModel != null ? active! : dark!,
            ),
          ],
        ),
      ),
    ),
  );
}

class CustomDataTable extends StatelessWidget {
  const CustomDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///columns
        _buildColumnHeaders(),
        const SizedBox(
          height: 10,
        ),
        Obx(() => productController.searchInAllProductList.isNotEmpty
            ? _buildListView(productController.searchInAllProductList)
            : _buildListView(productController.productList)),
      ],
    );
  }

  Widget _buildColumnHeaders() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: productController.csvHeaderList
              .map(
                (value) => Expanded(
                  child: InkWell(
                    onTap: () => productController.sortProducts(value),
                    child: Center(
                      child: CustomText(
                        text: value,
                        textStyle: headline5.copyWith(color: colorGreen),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildListView(List<ProductModel> list) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, index) {
          ProductModel model = list[index];
          return CustomContainer(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                dataCell(model.productCode),
                dataCell(model.productName),
                dataCell(model.companyCode),
                dataCell(model.companyName),
                dataActionCell(model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget dataCell(value) {
    return Expanded(
      child: Center(
        child: CustomText(
          text: "$value",
          textAlign: TextAlign.center,
          textStyle: bodyText3.copyWith(fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Widget dataActionCell(ProductModel model) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => showUpdateProductDialog(model),
            child: Tooltip(
              message: "Update Product",
              child: Icon(
                Icons.edit,
                color: colorTeal,
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Get.defaultDialog(
                title: "Delete Attention",
                titleStyle: headline3.copyWith(color: colorRed),
                middleText:
                    "Do you really wants to delete ${model.productName}?",
                textConfirm: "Delete",
                cancel: CustomButton(
                    width: 80,
                    height: 30,
                    color: dark,
                    onTap: () => Get.back(),
                    text: "No",
                    textStyle: headline6.copyWith(color: colorLight)),
                confirm: CustomButton(
                    width: 80,
                    height: 30,
                    color: colorRed,
                    onTap: () async {
                      await productController.deleteProductById(model);
                    },
                    text: "Yes",
                    textStyle: headline6.copyWith(color: colorLight)),
              );
            },
            child: Icon(
              Icons.delete,
              color: colorRed,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  void showUpdateProductDialog(ProductModel model) {
    productController.prodCodeController.text = model.productCode!;
    productController.prodNameController.text = model.productName!;
    productController.compCodeController.text = model.companyCode!;
    productController.compNameController.text = model.companyName!;

    Get.defaultDialog(
        title: "Update ${model.companyName}",
        titleStyle: headline3.copyWith(color: active),
        content: _addProductContents(productModel: model),
        backgroundColor: Colors.white);
  }
}
