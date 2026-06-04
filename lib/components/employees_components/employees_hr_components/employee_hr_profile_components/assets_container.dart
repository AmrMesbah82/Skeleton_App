import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo_app/core/widgets/buttons/main_custom_icon_button.dart';
import 'package:demo_app/core/widgets/column_request_data.dart';
import 'package:demo_app/core/theme/font_manager.dart';
import 'package:demo_app/core/theme/my_theme.dart';
import 'package:demo_app/core/theme/screen_size.dart';

class AssetsView extends StatefulWidget {
  AssetsView(
      {super.key,
      required this.asset,
      required this.assetDescription,
      required this.assetDescriptionState,
      required this.assetDescriptionfinishState,
      required this.assetId,
      required this.assetIdState,
      required this.assetIdfinishState,
      required this.assetName,
      required this.assetNameState,
      required this.assetNamefinishState,
      required this.assetState,
      required this.assetsCount,
      required this.assetsCountState,
      required this.secondAssetIdState,
      required this.secondAssetDescriptionState,
      required this.secondAssetNameState,
      required this.secondAssetState,
      this.isPreview = false,
      required this.selectedIndex,
      required this.widthOfData});
  int assetsCount;
  double widthOfData;
  List<String?> asset;
  List<TextEditingController> assetId;
  ValueChanged<List<TextEditingController>> assetIdState;
  ValueChanged<List<TextEditingController>> secondAssetIdState;
  ValueChanged? assetIdfinishState;
  List<TextEditingController> assetDescription;
  ValueChanged<List<TextEditingController>> assetDescriptionState;
  ValueChanged<List<TextEditingController>> secondAssetDescriptionState;
  ValueChanged? assetDescriptionfinishState;
  ValueChanged<int> assetsCountState;
  ValueChanged<List<String?>> assetState;
  ValueChanged<List<String?>> secondAssetState;
  List<TextEditingController> assetName;
  ValueChanged<List<TextEditingController>> assetNameState;
  ValueChanged<List<TextEditingController>> secondAssetNameState;
  ValueChanged? assetNamefinishState;
  final bool isPreview;
  int selectedIndex;
  @override
  State<AssetsView> createState() => _AssetsViewState();
}

class _AssetsViewState extends State<AssetsView> {
  bool hasSuffix2 = false;
  bool hasSuffix3 = false;
  bool hasSuffix4 = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 0.13.h * widget.assetsCount,
          child: ListView.builder(
padding: EdgeInsets.zero,
              itemCount: widget.assetsCount,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                print('widget.assetsCount : ${widget.assetsCount}');
                // widget.selectedIndex = index;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnRequestData(
                      title: "Asset",
                      isTextField: false,
                      dropDownItems: ["Yes".tr, "No".tr],
                      hint: "Asset",
                      isOptional: false,
                      buttonWidth: widget.widthOfData - 0.18.w,
                      dropdownValue: widget.asset[index],
                      dropDownValueState: (value) {
                        setState(() {
                          widget.asset[index] = value;
                          index == 0
                              ? widget.assetState(widget.asset)
                              : widget.secondAssetState(widget.asset);
                        });
                      },
                      isExpanded: true,
                      hasSuffix: true,
                      fillColor: Theme.of(context).colorScheme.inversePrimary,
                      suffixUrl: "assets/images/closefield.svg",
                    ),
                    SizedBox(
                      width: widget.widthOfData - 0.1.w,
                      child: ColumnRequestData(
                        title: "Asset Name",
                        isTextField: true,
                        hint: "Enter Asset Name",
                        isOptional: false,
                        textController: widget.assetName[index],
                        controllerfinishState: (value) {
                          setState(() {
                            widget.assetNamefinishState!(widget.assetName);
                            widget.assetNameState(widget.assetName);
                          });
                        },
                        controllerState: (value) {
                          setState(() {
                            index == 0
                                ? widget.assetNameState(widget.assetName)
                                : widget.secondAssetNameState(widget.assetName);
                          });
                        },
                        isExpanded: true,
                        hasSuffix: hasSuffix2,
                        hassSuffixState: (value) {
                          setState(() {
                            hasSuffix2 = value as bool;
                          });
                        },
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        suffixUrl: "assets/images/closefield.svg",
                      ),
                    ),
                    SizedBox(
                      width: widget.widthOfData - 0.12.w,
                      child: ColumnRequestData(
                        title: "Asset ID",
                        isTextField: true,
                        hint: "Enter Asset Id",
                        isOptional: false,
                        textController: widget.assetId[index],
                        controllerfinishState: (value) {
                          setState(() {
                            widget.assetIdfinishState!(widget.assetId);
                            widget.assetIdState(widget.assetId);
                          });
                        },
                        controllerState: (value) {
                          setState(() {
                            index == 0
                                ? widget.assetIdState(widget.assetId)
                                : widget.secondAssetIdState(widget.assetId);
                          });
                        },
                        isExpanded: true,
                        hasSuffix: hasSuffix3,
                        hassSuffixState: (value) {
                          setState(() {
                            hasSuffix3 = value as bool;
                          });
                        },
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        suffixUrl: "assets/images/closefield.svg",
                      ),
                    ),
                    SizedBox(
                      width: widget.widthOfData + 0.14.w,
                      child: ColumnRequestData(
                        title: "Asset Description",
                        isTextField: true,
                        hint: "Enter Asset Description",
                        isOptional: false,
                        textController: widget.assetDescription[index],
                        controllerfinishState: (value) {
                          setState(() {
                            widget.assetDescriptionfinishState!(
                                widget.assetDescription);
                            widget
                                .assetDescriptionState(widget.assetDescription);
                          });
                        },
                        controllerState: (value) {
                          setState(() {
                            index == 0
                                ? widget.assetDescriptionState(
                                    widget.assetDescription)
                                : widget.secondAssetDescriptionState(
                                    widget.assetDescription);
                          });
                        },
                        isExpanded: true,
                        hasSuffix: hasSuffix4,
                        hassSuffixState: (value) {
                          setState(() {
                            hasSuffix4 = value as bool;
                          });
                        },
                        fillColor: Theme.of(context).colorScheme.inversePrimary,
                        suffixUrl: "assets/images/closefield.svg",
                      ),
                    ),
                  ],
                );
              }),
        ),
        widget.isPreview || widget.assetsCount > 1
            ? const SizedBox.shrink()
            : Padding(
                padding: EdgeInsets.only(top: 0.01.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    MainCustomIconButton(
                      onPressed: () {
                        setState(() {
                          widget.assetsCount += 1;
                          widget.assetsCountState(widget.assetsCount);
                          widget.asset.add(null);
                          widget.assetName.add(TextEditingController());
                          widget.assetId.add(TextEditingController());
                          widget.assetDescription.add(TextEditingController());
                          widget.assetState(widget.asset);
                          widget.assetNameState(widget.assetName);
                          widget.assetIdState(widget.assetId);
                          widget.assetDescriptionState(widget.assetDescription);
                        });
                        print(widget.asset.length);
                      },
                      buttonText: "Add Asset".tr,
                    
                      buttonStyle: ElevatedButton.styleFrom(
                        minimumSize: Size(0.085.w, 0.045.h),
                        backgroundColor:
                            Theme.of(context).colorScheme.onTertiaryContainer,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                      ),
                    )
                  ],
                ),
              )
      ],
    );
  }
}
