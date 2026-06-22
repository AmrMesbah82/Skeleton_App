import 'dart:typed_data';
import 'dart:io';
import 'package:demo_app/features/services_management_module/data/models/model_employee.dart';

/// Immutable form data model for create/edit service
class CreateServiceFormData {
  final String? docId;
  final String serviceNameEn;
  final String serviceNameAr;
  final String descriptionEn;
  final String descriptionAr;
  final String durationValue;
  final String durationUnit;
  final String? imageUrl;
  final bool isActive;
  final bool isEditMode;
  final String state;
  final List<EmployeeEntityModell> providers;

  const CreateServiceFormData({
    this.docId,
    this.serviceNameEn = '',
    this.serviceNameAr = '',
    this.descriptionEn = '',
    this.descriptionAr = '',
    this.durationValue = '',
    this.durationUnit = 'minutes',
    this.imageUrl,
    this.isActive = true,
    this.isEditMode = false,
    this.state = 'draft',
    this.providers = const [],
  });

  CreateServiceFormData copyWith({
    String? docId,
    String? serviceNameEn,
    String? serviceNameAr,
    String? descriptionEn,
    String? descriptionAr,
    String? durationValue,
    String? durationUnit,
    String? imageUrl,
    bool? isActive,
    bool? isEditMode,
    String? state,
    List<EmployeeEntityModell>? providers,
  }) {
    return CreateServiceFormData(
      docId: docId ?? this.docId,
      serviceNameEn: serviceNameEn ?? this.serviceNameEn,
      serviceNameAr: serviceNameAr ?? this.serviceNameAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      durationValue: durationValue ?? this.durationValue,
      durationUnit: durationUnit ?? this.durationUnit,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      isEditMode: isEditMode ?? this.isEditMode,
      state: state ?? this.state,
      providers: providers ?? this.providers,
    );
  }

  bool get isFormValid {
    final isArabic = RegExp(r'[\u0600-\u06FF]');
    final isEnglish = RegExp(r'[a-zA-Z]');
    final isDigits = RegExp(r'^\d+$');

    return serviceNameEn.trim().isNotEmpty &&
        serviceNameAr.trim().isNotEmpty &&
        descriptionEn.trim().isNotEmpty &&
        descriptionAr.trim().isNotEmpty &&
        durationValue.trim().isNotEmpty &&
        durationUnit.trim().isNotEmpty &&
        !isArabic.hasMatch(serviceNameEn) &&
        !isEnglish.hasMatch(serviceNameAr) &&
        !isArabic.hasMatch(descriptionEn) &&
        !isEnglish.hasMatch(descriptionAr) &&
        isDigits.hasMatch(durationValue);
  }
}
