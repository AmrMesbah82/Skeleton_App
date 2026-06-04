import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/form_fields/profile_textfield.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class CountryCitySection extends StatefulWidget {
  final Function(String)? countryOnChanged;
  final String? Function(String?)? countryValidator;
  final String? countryInitialValue;
  final String countryHint;


  final Function(String)? cityOnChanged;
  final String? Function(String?)? cityValidator;
  final String? cityInitialValue;
  final String cityHint;

 
   

  const CountryCitySection({
    Key? key,
    this.countryOnChanged,
    this.countryValidator,
    this.cityOnChanged,
    this.cityValidator,
    
    this.countryInitialValue,
    this.cityInitialValue,
     
    required this.countryHint,
    required this.cityHint,

 
 
  }) : super(key: key);

  @override
  State<CountryCitySection> createState() => _CountryCitySectionState();
}

class _CountryCitySectionState extends State<CountryCitySection> {
  @override
  Widget build(BuildContext context) {
    bool isVertical =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return isVertical
        ? Column(
            children: [
             Stack(
                    children: [
                      textfieled(
                        context,
                        (value) async {
                          widget.countryOnChanged;
                        },
                        (value) {
                        widget.countryValidator;
                        },
                        widget.countryHint.tr,
                        widget.countryInitialValue,
                        null, // prefixIcon
                        controller: null,
                        isReadOnly: true,
                      ),
                      InkWell(
                          onTap: (() async {
                            setState(() {
                              //    showLoadingIndicator();
                            });
                            //    address = await getUserLocation();
                            setState(() {
                              //      hideLoadingIndicator();
                            });

                            //    country = address?.country;
                          }),
                          child: Container(
                            width: double.infinity,
                            height: 46,
                            color: Colors.transparent,
                          )),
                    ],
                  ),

                  Stack(
                  children: [
                    textfieled(
                      context,
                      (value) async {
                       widget.cityOnChanged;
                      },
                      (value) {
                       widget.cityValidator;
                      },
                      widget.cityHint.tr,
                      widget.cityInitialValue,
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: true,
                    ),
                    InkWell(
                        onTap: (() async {
                          setState(() {
                            //    showLoadingIndicator();
                          });
                          //    address = await getUserLocation();
                          setState(() {
                            //      hideLoadingIndicator();
                          });
                          //     city = address?.subAdministrativeArea;
                        }),
                        child: Container(
                          width: double.infinity,
                          height: 46,
                          color: Colors.transparent,
                        )),
                   
                  ],
                ),
            ],
          )
        : Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      right: Get.locale.toString().contains('en') ? 0.02.h : 0,
                      left: Get.locale.toString().contains('ar') ? 0.02.h : 0),
                  child: Stack(
                    children: [
                      textfieled(
                        context,
                        (value) async {
                          widget.countryOnChanged;
                        },
                        (value) {
                        widget.countryValidator;
                        },
                        widget.countryHint.tr,
                        widget.countryInitialValue,
                        null, // prefixIcon
                        controller: null,
                        isReadOnly: true,
                      ),
                      InkWell(
                          onTap: (() async {
                            setState(() {
                              //    showLoadingIndicator();
                            });
                            //    address = await getUserLocation();
                            setState(() {
                              //      hideLoadingIndicator();
                            });

                            //    country = address?.country;
                          }),
                          child: Container(
                            width: double.infinity,
                            height: 46,
                            color: Colors.transparent,
                          )),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    textfieled(
                      context,
                      (value) async {
                       widget.cityOnChanged;
                      },
                      (value) {
                       widget.cityValidator;
                      },
                      widget.cityHint.tr,
                      widget.cityInitialValue,
                      null, // prefixIcon
                      controller: null,
                      isReadOnly: true,
                    ),
                    InkWell(
                        onTap: (() async {
                          setState(() {
                            //    showLoadingIndicator();
                          });
                          //    address = await getUserLocation();
                          setState(() {
                            //      hideLoadingIndicator();
                          });
                          //     city = address?.subAdministrativeArea;
                        }),
                        child: Container(
                          width: double.infinity,
                          height: 46,
                          color: Colors.transparent,
                        )),
                   
                  ],
                ),
              ),
            ],
          );
  }
}
