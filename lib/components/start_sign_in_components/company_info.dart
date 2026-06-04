import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/components/home_components/custom_create_task_container.dart';
import 'package:demo_app/components/start_sign_in_components/custom_textfield.dart';
import 'package:demo_app/core/theme/screen_size.dart';
import 'package:demo_app/core/helper/validator.dart';

// ignore: must_be_immutable
class CompanyInfoView extends StatefulWidget {
  CompanyInfoView(
      {super.key,
      required this.cityVal,
      required this.nameValState,
      required this.taxValState,
      required this.addressValState,
      required this.zipValState,
      required this.provinceValState,
      required this.countryValState,
      required this.cityValState,
      required this.companyInformation,
      required this.compInfoState});
  String? cityVal;
  ValueChanged<String?> nameValState;
  ValueChanged<String?> taxValState;
  ValueChanged<String?> addressValState;
  ValueChanged<String?> cityValState;
  ValueChanged<String?> zipValState;
  ValueChanged<String?> provinceValState;
  ValueChanged<String?> countryValState;
  double companyInformation;
  ValueChanged<double> compInfoState;

  @override
  State<CompanyInfoView> createState() => _CompanyInfoViewState();
}

class _CompanyInfoViewState extends State<CompanyInfoView> {
  TextEditingController name = TextEditingController();
  TextEditingController tax = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController zip = TextEditingController();
  TextEditingController provi = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    bool isTablet = MediaQuery.of(context).size.shortestSide > 600;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double heightSpacer = 0.02.h;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isPortrait ? MainAxisAlignment.start : MainAxisAlignment.start,
        children: <Widget>[
          CustomField(
              controller: name,
              onfinishState: (value) {
                setState(() {
                  widget.companyInformation += 1 / 7;
                  widget.nameValState(value.text);
                  widget.compInfoState(widget.companyInformation);
                });
              },
              validator: (value) {
                return Validator.work(value, "Invalid Company Name".tr);
              },
              hintText: "Company Name",
              imagePath: "assets/images/company_name.svg"),
          SizedBox(
            height: isTablet ? heightSpacer : height,
          ),
          CustomField(
              controller: tax,
              hintText: "Tax Number",
              validator: (value) {
                return Validator.validateTaxNumber(
                  value,
                );
              },
              onfinishState: (value) {
                setState(() {
                  widget.companyInformation += 1 / 7;
                  widget.taxValState(value.text);
                  widget.compInfoState(widget.companyInformation);
                });
              },
              imagePath: "assets/images/tax.svg"),
          SizedBox(
            height: isTablet ? heightSpacer : height,
          ),
          isTablet
              ? Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: isPortrait ? 0.43.w : 0.3.w,
                            child: CustomField(
                                controller: country,
                                hintText: "Country",
                                validator: (value) {
                                  return Validator.work(value, "Invalid Country".tr);
                                },
                                onfinishState: (value) {
                                  setState(() {
                                    widget.countryValState(value.text);
                                    widget.companyInformation += 1 / 7;
                                    widget.compInfoState(widget.companyInformation);
                                  });
                                },
                                imagePath: "assets/images/loc.svg"),
                          ),
                        ),
                        SizedBox(width:isPortrait? 0.02.w : 0.01.w,),
                        Expanded(
                          child: SizedBox(
                            width: isPortrait ? 0.43.w : 0.3.w,
                            child: CustomField(
                                controller: provi,
                                hintText: "Province",
                                validator: (value) {
                                  return Validator.work(value, "Invalid Province".tr);
                                },
                                onfinishState: (value) {
                                  setState(() {
                                    widget.provinceValState(value.text);
                                    widget.companyInformation += 1 / 7;
                                    widget.compInfoState(widget.companyInformation);
                                  });
                                },
                                imagePath: "assets/images/loc.svg"),
                          ),
                        ),
                      ],
                    ),
                     SizedBox(
                      height: heightSpacer,
                    ),
                ],
              )
              : Column(
                  children: [
                    SizedBox(
                      child: CustomField(
                          controller: country,
                          hintText: "Country",
                          validator: (value) {
                            return Validator.work(value, "Invalid Country".tr);
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.countryValState(value.text);
                              widget.companyInformation += 1 / 7;
                              widget.compInfoState(widget.companyInformation);
                            });
                          },
                          imagePath: "assets/images/loc.svg"),
                    ),
                    SizedBox(
                      height: isTablet ? 0 : height,
                    ),
                    SizedBox(
                      child: CustomField(
                          controller: provi,
                          hintText: "Province",
                          validator: (value) {
                            return Validator.work(value, "Invalid Province".tr);
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.provinceValState(value.text);
                              widget.companyInformation += 1 / 7;
                              widget.compInfoState(widget.companyInformation);
                            });
                          },
                          imagePath: "assets/images/loc.svg"),
                    ),
                    SizedBox(
                      height: isTablet ? 0 : height,
                    ),
                  ],
                ),
          isTablet
              ? Column(
                
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: isPortrait ? 0.55.w : 0.38.w,
                            child: CustomField(
                                controller: city,
                                hintText: "City",
                                validator: (value) {
                                  return Validator.work(value, "Invalid City".tr);
                                },
                                onfinishState: (value) {
                                  setState(() {
                                    widget.cityValState(value.text);
                                    widget.companyInformation += 1 / 7;
                                    widget.compInfoState(widget.companyInformation);
                                  });
                                },
                                imagePath: "assets/images/loc.svg"),
                          ),
                        ),
                        SizedBox(width:isPortrait? 0.02.w : 0.01.w,),
                        Expanded(
                          child: SizedBox(
                            width: isPortrait ? 0.3.w : 0.2.w,
                            child: CustomField(
                                controller: zip,
                                hintText: "Zip Code",
                                validator: (value) {
                                  return Validator.zip(
                                    value,
                                  );
                                },
                                onfinishState: (value) {
                                  setState(() {
                                    widget.zipValState(value.text);
                                    widget.companyInformation += 1 / 7;
                                    widget
                                        .compInfoState(widget.companyInformation);
                                  });
                                },
                                imagePath: "assets/images/Mailbox.svg"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: heightSpacer,
                    ),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      child: CustomField(
                          controller: city,
                          hintText: "City",
                          validator: (value) {
                            return Validator.work(value, "Invalid City".tr);
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.cityValState(value.text);
                              widget.companyInformation += 1 / 7;
                              widget.compInfoState(widget.companyInformation);
                            });
                          },
                          imagePath: "assets/images/loc.svg"),
                    ),
                    SizedBox(
                      height: isTablet ? 0 : height,
                    ),
                    SizedBox(
                      child: CustomField(
                          controller: zip,
                          hintText: "Zip Code",
                          validator: (value) {
                            return Validator.zip(
                              value,
                            );
                          },
                          onfinishState: (value) {
                            setState(() {
                              widget.zipValState(value.text);
                              widget.companyInformation += 1 / 7;
                              widget.compInfoState(widget.companyInformation);
                            });
                          },
                          imagePath: "assets/images/Mailbox.svg"),
                    ),
                    SizedBox(
                      height: isTablet ? 0 : height,
                    ),
                  ],
                ),
          CustomField(
              controller: address,
              hintText: "Company Address",
              validator: (value) {
                return Validator.work(value, "Invalid Company Address".tr);
              },
              onfinishState: (value) {
                setState(() {
                  widget.addressValState(value.text);
                  widget.companyInformation += 1 / 7;
                  widget.compInfoState(widget.companyInformation);
                });
              },
              imagePath: "assets/images/comp_address.svg"),
        ],
      ),
    );
  }
}
