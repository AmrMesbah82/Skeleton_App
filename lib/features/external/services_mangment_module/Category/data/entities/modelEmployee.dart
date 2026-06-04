

import '../../../../main_core/features/employee/domain/entities/mobile_phone_entity.dart';

class ServicesMobilePhoneEntity {
  final String? phone;
  final String? countryCode;
  final String? countryApp;

  ServicesMobilePhoneEntity({
    this.phone,
    this.countryCode,
    this.countryApp,
  });
  factory ServicesMobilePhoneEntity.fromMobilePhoneEntity(
      MobilePhoneEntity entity) {
    return ServicesMobilePhoneEntity(
      phone: entity.phone,
      countryCode: entity.countryCode,
      countryApp: entity.countryApp,
    );
  }
  factory ServicesMobilePhoneEntity.fromJson(Map<String, dynamic> json) {
    return ServicesMobilePhoneEntity(
      phone: json['phone'],
      countryCode: json['countryCode'],
      countryApp: json['countryApp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'countryCode': countryCode,
      'countryApp': countryApp,
    };
  }
}

class AcademicHistoryEntity {
  final String? gpa;
  final String? graduateFrom;
  final String? university;
  final String? yearOfGraduation;
  final String? graduateFromStatus;
  final String? universityStatus;
  final String? yearOfGraduationStatus;
  final String? gpaStatus;

  AcademicHistoryEntity({
    this.gpa,
    this.graduateFrom,
    this.university,
    this.yearOfGraduation,
    this.graduateFromStatus,
    this.universityStatus,
    this.yearOfGraduationStatus,
    this.gpaStatus,
  });

  factory AcademicHistoryEntity.fromJson(Map<String, dynamic> json) {
    return AcademicHistoryEntity(
      gpa: json['gpa'],
      graduateFrom: json['graduateFrom'],
      university: json['university'],
      yearOfGraduation: json['yearOfGraduation'],
      graduateFromStatus: json['graduateFromStatus'],
      universityStatus: json['universityStatus'],
      yearOfGraduationStatus: json['yearOfGraduationStatus'],
      gpaStatus: json['gpaStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gpa': gpa,
      'graduateFrom': graduateFrom,
      'university': university,
      'yearOfGraduation': yearOfGraduation,
      'graduateFromStatus': graduateFromStatus,
      'universityStatus': universityStatus,
      'yearOfGraduationStatus': yearOfGraduationStatus,
      'gpaStatus': gpaStatus,
    };
  }
}

class EmployeeEntityModell {
  final String? id;

  late final String? state;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? firstNameInArabic;
  final String? middleNameInArabic;
  final String? lastNameInArabic;
  final String? nationalId;
  final String? nationalIdExpirationDate;
  final String? nationality;
  final String? passport;
  final String? passportExpirationDate;
  final String? email;
  final ServicesMobilePhoneEntity? mobilePhone;
  final String? officePhone;
  final String? homePhone;
  final String? extension;
  final String? birthDay;
  final String? gender;
  final String? country;
  final String? imageUrl;
  final String? province;
  final String? city;
  final String? postalCode;
  final String? street;
  final String? maritalStatus;
  final String? language;
  final String? departmentId;
  final String? supervisor;
  final String? role;
  final String? title;
  final String? titleInArabic;
  final String? workLocation;
  final String? drivingLicenseId;
  final List<String?>? carPlates;
  final AcademicHistoryEntity? academicHistory;
  final String? bio;
  final String? photo;
  final List<String?>? skills;
  final List<String?>? hobbies;
  final String? status;
  final String? password;
  final String? defaultPassword;
  final String? firstLogin;
  final String? lastLogin;
  final String? deactivationDate;
  final String? activationDate;

  EmployeeEntityModell({
    this.id,
    this.state,
    this.firstName,
    this.middleName,
    this.lastName,
    this.firstNameInArabic,
    this.middleNameInArabic,
    this.lastNameInArabic,
    this.nationalId,
    this.nationalIdExpirationDate,
    this.nationality,
    this.passport,
    this.passportExpirationDate,
    this.email,
    this.mobilePhone,
    this.officePhone,
    this.homePhone,
    this.extension,
    this.birthDay,
    this.gender,
    this.country,
    this.imageUrl,
    this.province,
    this.city,
    this.postalCode,
    this.street,
    this.maritalStatus,
    this.language,
    this.departmentId,
    this.supervisor,
    this.role,
    this.title,
    this.titleInArabic,
    this.workLocation,
    this.drivingLicenseId,
    this.carPlates,
    this.academicHistory,
    this.bio,
    this.photo,
    this.skills,
    this.hobbies,
    this.status,
    this.password,
    this.defaultPassword,
    this.firstLogin,
    this.lastLogin,
    this.deactivationDate,
    this.activationDate,
  });





  EmployeeEntityModell copyWith({
    String? id,
    String? state,
    String? firstName,
    String? middleName,
    String? lastName,
    String? firstNameInArabic,
    String? middleNameInArabic,
    String? lastNameInArabic,
    String? nationalId,
    String? nationalIdExpirationDate,
    String? nationality,
    String? passport,
    String? passportExpirationDate,
    String? email,
    ServicesMobilePhoneEntity? mobilePhone,
    String? officePhone,
    String? homePhone,
    String? extension,
    String? birthDay,
    String? gender,
    String? country,
    String? imageUrl,
    String? province,
    String? city,
    String? postalCode,
    String? street,
    String? maritalStatus,
    String? language,
    String? departmentId,
    String? supervisor,
    String? role,
    String? title,
    String? titleInArabic,
    String? workLocation,
    String? drivingLicenseId,
    List<String?>? carPlates,
    AcademicHistoryEntity? academicHistory,
    String? bio,
    String? photo,
    List<String?>? skills,
    List<String?>? hobbies,
    String? status,
    String? password,
    String? defaultPassword,
    String? firstLogin,
    String? lastLogin,
    String? deactivationDate,
    String? activationDate,
  }) {
    return EmployeeEntityModell(
      id: id ?? this.id,
      state: state ?? this.state,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      firstNameInArabic: firstNameInArabic ?? this.firstNameInArabic,
      middleNameInArabic: middleNameInArabic ?? this.middleNameInArabic,
      lastNameInArabic: lastNameInArabic ?? this.lastNameInArabic,
      nationalId: nationalId ?? this.nationalId,
      nationalIdExpirationDate: nationalIdExpirationDate ?? this.nationalIdExpirationDate,
      nationality: nationality ?? this.nationality,
      passport: passport ?? this.passport,
      passportExpirationDate: passportExpirationDate ?? this.passportExpirationDate,
      email: email ?? this.email,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      officePhone: officePhone ?? this.officePhone,
      homePhone: homePhone ?? this.homePhone,
      extension: extension ?? this.extension,
      birthDay: birthDay ?? this.birthDay,
      imageUrl: imageUrl ?? this.imageUrl,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      province: province ?? this.province,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      street: street ?? this.street,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      language: language ?? this.language,
      departmentId: departmentId ?? this.departmentId,
      supervisor: supervisor ?? this.supervisor,
      role: role ?? this.role,
      title: title ?? this.title,
      titleInArabic: titleInArabic ?? this.titleInArabic,
      workLocation: workLocation ?? this.workLocation,
      drivingLicenseId: drivingLicenseId ?? this.drivingLicenseId,
      carPlates: carPlates ?? this.carPlates,
      academicHistory: academicHistory ?? this.academicHistory,
      bio: bio ?? this.bio,
      photo: photo ?? this.photo,
      skills: skills ?? this.skills,
      hobbies: hobbies ?? this.hobbies,
      status: status ?? this.status,
      password: password ?? this.password,
      defaultPassword: defaultPassword ?? this.defaultPassword,
      firstLogin: firstLogin ?? this.firstLogin,
      lastLogin: lastLogin ?? this.lastLogin,
      deactivationDate: deactivationDate ?? this.deactivationDate,
      activationDate: activationDate ?? this.activationDate,
    );
  }


  factory EmployeeEntityModell.fromEntity(dynamic entity) {
    if (entity is EmployeeEntityModell) return entity;

    return EmployeeEntityModell(
      id: entity.id,
      state: entity.state,
      firstName: entity.firstName,
      middleName: entity.middleName,
      lastName: entity.lastName,
      firstNameInArabic: entity.firstNameInArabic,
      middleNameInArabic: entity.middleNameInArabic,
      lastNameInArabic: entity.lastNameInArabic,
      nationalId: entity.nationalId,
      nationalIdExpirationDate: entity.nationalIdExpirationDate,
      nationality: entity.nationality,
      passport: entity.passport,
      passportExpirationDate: entity.passportExpirationDate,
      email: entity.email,
      mobilePhone: entity.mobilePhone,
      officePhone: entity.officePhone,
      homePhone: entity.homePhone,
      extension: entity.extension,
      birthDay: entity.birthDay,
      gender: entity.gender,
      country: entity.country,
      imageUrl: entity.imageUrl,
      province: entity.province,
      city: entity.city,
      postalCode: entity.postalCode,
      street: entity.street,
      maritalStatus: entity.maritalStatus,
      language: entity.language,
      departmentId: entity.departmentId,
      supervisor: entity.supervisor,
      role: entity.role,
      title: entity.title,
      titleInArabic: entity.titleInArabic,
      workLocation: entity.workLocation,
      drivingLicenseId: entity.drivingLicenseId,
      carPlates: entity.carPlates,
      academicHistory: entity.academicHistory,
      bio: entity.bio,
      photo: entity.photo,
      skills: entity.skills,
      hobbies: entity.hobbies,
      status: entity.status,
      password: entity.password,
      defaultPassword: entity.defaultPassword,
      firstLogin: entity.firstLogin,
      lastLogin: entity.lastLogin,
      deactivationDate: entity.deactivationDate,
      activationDate: entity.activationDate,
    );
  }



  factory EmployeeEntityModell.fromJson(Map<String, dynamic> json) {
    return EmployeeEntityModell(
      id: json['id'],
      state: json['state'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      firstNameInArabic: json['firstNameInArabic'],
      middleNameInArabic: json['middleNameInArabic'],
      lastNameInArabic: json['lastNameInArabic'],
      nationalId: json['nationalId'],
      nationalIdExpirationDate: json['nationalIdExpirationDate'],
      nationality: json['nationality'],
      passport: json['passport'],
      passportExpirationDate: json['passportExpirationDate'],
      email: json['email'],
      mobilePhone: json['mobilePhone'] != null
          ? ServicesMobilePhoneEntity.fromJson(json['mobilePhone'])
          : null,
      officePhone: json['officePhone'],
      homePhone: json['homePhone'],
      extension: json['extension'],
      birthDay: json['birthDay'],
      gender: json['gender'],
      country: json['country'],
      imageUrl: json['imageUrl'],
      province: json['province'],
      city: json['city'],
      postalCode: json['postalCode'],
      street: json['street'],
      maritalStatus: json['maritalStatus'],
      language: json['language'],
      departmentId: json['departmentId'],
      supervisor: json['supervisor'],
      role: json['role'],
      title: json['title'],
      titleInArabic: json['titleInArabic'],
      workLocation: json['workLocation'],
      drivingLicenseId: json['drivingLicenseId'],
      carPlates: (json['carPlates'] as List?)?.cast<String?>(),
      academicHistory: json['academicHistory'] != null
          ? AcademicHistoryEntity.fromJson(json['academicHistory'])
          : null,
      bio: json['bio'],
      photo: json['photo'],
      skills: (json['skills'] as List?)?.cast<String?>(),
      hobbies: (json['hobbies'] as List?)?.cast<String?>(),
      status: json['status'],
      password: json['password'],
      defaultPassword: json['defaultPassword'],
      firstLogin: json['firstLogin'],
      lastLogin: json['lastLogin'],
      deactivationDate: json['deactivationDate'],
      activationDate: json['activationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state': state,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'firstNameInArabic': firstNameInArabic,
      'middleNameInArabic': middleNameInArabic,
      'lastNameInArabic': lastNameInArabic,
      'nationalId': nationalId,
      'nationalIdExpirationDate': nationalIdExpirationDate,
      'nationality': nationality,
      'passport': passport,
      'passportExpirationDate': passportExpirationDate,
      'email': email,
      'mobilePhone': mobilePhone?.toJson(),
      'officePhone': officePhone,
      'homePhone': homePhone,
      'extension': extension,
      'birthDay': birthDay,
      'gender': gender,
      'country': country,
      'imageUrl': imageUrl,
      'province': province,
      'city': city,
      'postalCode': postalCode,
      'street': street,
      'maritalStatus': maritalStatus,
      'language': language,
      'departmentId': departmentId,
      'supervisor': supervisor,
      'role': role,
      'title': title,
      'titleInArabic': titleInArabic,
      'workLocation': workLocation,
      'drivingLicenseId': drivingLicenseId,
      'carPlates': carPlates,
      'academicHistory': academicHistory?.toJson(),
      'bio': bio,
      'photo': photo,
      'skills': skills,
      'hobbies': hobbies,
      'status': status,
      'password': password,
      'defaultPassword': defaultPassword,
      'firstLogin': firstLogin,
      'lastLogin': lastLogin,
      'deactivationDate': deactivationDate,
      'activationDate': activationDate,
    };
  }
}