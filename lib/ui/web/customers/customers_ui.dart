import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ikram_enterprise/constants/app_colors.dart';
import 'package:ikram_enterprise/constants/app_text_styles.dart';
import 'package:ikram_enterprise/constants/controller_base.dart';
import 'package:ikram_enterprise/helpers/responsiveness.dart';
import 'package:ikram_enterprise/models/customer_model.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_button.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_container.dart';
import 'package:ikram_enterprise/ui/web/widgets/custom_text.dart';
import 'package:ikram_enterprise/ui/web/widgets/form_input_field_with_icon.dart';
import 'package:ikram_enterprise/utils/validator.dart';

class CustomersPage extends StatelessWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    customerController.addListenerToController(context);
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
            controller: customerController.scrollController,
            shrinkWrap: true,
            //physics: const NeverScrollableScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomContainer(
                      padding: const EdgeInsets.all(8),
                      child: FormInputFieldWithIcon(
                        controller: customerController.searchController,
                        iconPrefix: Icons.search,
                        labelText: 'Search',
                        hint: "Search by Customer Name/Code or Area Name/Code",
                        iconColor: active!,
                        autofocus: false,
                        textStyle: bodyText1,
                        keyboardType: TextInputType.text,
                        onChanged: (value) => customerController
                            .handleCustomerSearch(value.toLowerCase()),
                        onSaved: (value) => {},
                      ),
                    ),
                  ),
                  Expanded(flex: 2, child: Container()),
                  CustomButton(
                    onTap: () => showAddCustomerDialog(context),
                    text: "Add Customer",
                    width: 120,
                    height: 40,
                    color: dark!,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomButton(
                    onTap: () => customerController.importCsvFromStorage(),
                    text: "Import csv",
                    width: 120,
                    height: 40,
                    color: active!,
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: _customDataTable(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAddCustomerDialog(context) {
    customerController.clearControllers();
    Get.defaultDialog(
        title: "Add Customer",
        titleStyle: headline3,
        content: _bottomSheetContents(),
        backgroundColor: Colors.white);
  }

  Widget _bottomSheetContents({CustomerModel? customerModel}) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var error = false.obs;

    return Container(
      width: 400,
      height: 400,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FormInputFieldWithIcon(
                controller: customerController.codeController,
                iconPrefix: Icons.code,
                labelText: 'Customer Code',
                hint: "Code e.g. 1207...",
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
                controller: customerController.nameController,
                iconPrefix: Icons.person,
                labelText: 'Customer Name',
                hint: "customer name",
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
                controller: customerController.areaCodeController,
                iconPrefix: Icons.code,
                labelText: 'Area Code',
                hint: "Area Code e.g. 1,2,3",
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
                controller: customerController.areaNameController,
                iconPrefix: Icons.location_pin,
                labelText: 'Area Name',
                hint: "Area Name e.g. TMG, BJR/PSHT/RGH",
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().notEmpty,
                keyboardType: TextInputType.text,
                onChanged: (value) => {},
                onSaved: (value) => {},
              ),
              const SizedBox(
                height: 15,
              ),
              FormInputFieldWithIcon(
                controller: customerController.addressController,
                iconPrefix: Icons.location_city,
                labelText: 'Address',
                hint: "Full address in specific area",
                iconColor: active!.withOpacity(0.85),
                autofocus: false,
                validator: Validator().notEmpty,
                keyboardType: TextInputType.emailAddress,
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
                    if (customerModel != null) {
                      customerModel.code =
                          customerController.codeController.text;
                      customerModel.name =
                          customerController.nameController.text;
                      customerModel.areaCode =
                          customerController.areaCodeController.text;
                      customerModel.areaName =
                          customerController.areaNameController.text;
                      customerModel.address =
                          customerController.addressController.text;

                      await customerController.updateCustomer(customerModel);
                    } else {
                      await customerController.createCustomer();
                    }
                    error.value = false;
                    Get.back();
                  } else {
                    error.value = true;
                  }
                },
                text: customerModel != null ? "Update" : "Submit",
                width: 150,
                height: 40,
                color: customerModel != null ? active : dark!,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customDataTable(context) {
    return Column(
      children: [
        ///columns
        Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: customerController.columnHeaders
                  .map(
                    (value) => Expanded(
                      child: InkWell(
                        onTap: () => customerController.sortCustomerList(value),
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
        ),
        const SizedBox(
          height: 10,
        ),

        Obx(
          () => customerController.customerSearchList.isNotEmpty
              ? _buildListView(customerController.customerSearchList)
              : _buildAdminListView(),
        ),
      ],
    );
  }

  _buildListView(List<CustomerModel> list) {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (_, index) {
          CustomerModel model = list[index];
          return CustomContainer(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                dataCell(model.code),
                dataCell(model.name),
                dataCell(model.address),
                dataCell(model.areaCode),
                dataCell(model.areaName),
                dataActionCell(model),
              ],
            ),
          );
        },
      ),
    );
  }

  _buildAdminListView() {

    debugPrint("CustomerList: ${customerController.adminCustomersList.length}");

    return Obx(
      () => Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            // physics: const AlwaysScrollableScrollPhysics(),
            itemCount: customerController.adminCustomersList.length,
            itemBuilder: (_, index) {
              CustomerModel model = CustomerModel.fromDoc(customerController.adminCustomersList[index].data());
              return CustomContainer(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    dataCell(model.code),
                    dataCell(model.name),
                    dataCell(model.address),
                    dataCell(model.areaCode),
                    dataCell(model.areaName),
                    dataActionCell(model),
                  ],
                ),
              );
            },
          ),
          customerController.isLoading.isTrue
              ? CustomContainer(
                width: 300,
                  padding: const EdgeInsets.all(8.0),
                  child: CustomText(
                    textAlign: TextAlign.center,
                    text: "Loading...",
                    textStyle: headline6,
                  ),
                )
              : Container()
        ],
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

  Widget dataActionCell(CustomerModel model) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          InkWell(
            onTap: () => showUpdateCustomerDialog(model),
            child: Tooltip(
              message: "Update Customer",
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
                middleText: "Do you really wants to delete ${model.name}?",
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
                      await customerController.deleteCustomer(model);
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

  void showUpdateCustomerDialog(CustomerModel model) {
    customerController.codeController.text = model.code!;
    customerController.nameController.text = model.name!;
    customerController.areaCodeController.text = model.areaCode!;
    customerController.areaNameController.text = model.areaName!;
    customerController.addressController.text = model.address!;

    Get.defaultDialog(
        title: "Update ${model.name}",
        titleStyle: headline3.copyWith(color: active!),
        content: _bottomSheetContents(),
        backgroundColor: Colors.white);
  }
}
