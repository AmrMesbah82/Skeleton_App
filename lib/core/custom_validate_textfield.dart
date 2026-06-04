  import 'package:demo_app/features/external/main_core/core/theme/new_theme.dart';
import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import 'package:flutter_screenutil/flutter_screenutil.dart';
  import 'package:flutter_svg/svg.dart';
// REMOVED_MODULE: import 'package:demo_app/features/external/knowledge_hub_module/core/theming/new_theme.dart';

  import '../features/external/main_core/core/theme/app_colors.dart';
  import '../features/external/main_core/core/theme/app_theme.dart';

  /// Enum for different validation types
  enum ValidationType {
    none,
    email,
    phone,
    password,
    number,
    custom,
    required,
    minLength,
    maxLength,
    alphanumeric,
    url,
    creditCard,
  }

  /// Enum for supported languages
  enum AppLanguage {
    english,
    arabic,
  }

  /// Custom Validated Text Form Field with Bilingual Support (AR/EN)
  class CustomKnowticedTextField extends StatefulWidget {
    // Basic Properties
    final String labelEn;
    final String labelAr;
    final String hintEn;
    final String hintAr;
    final TextEditingController controller;
    final FocusNode? focusNode;

    // Language & Direction
    final AppLanguage language;
    final TextDirection? textDirection;

    // Validation
    final ValidationType validationType;
    final String? Function(String?)? customValidator;
    final bool isRequired;
    final int? minLength;
    final int? maxLength;

    // Input Configuration
    final TextInputType keyboardType;
    final TextInputAction textInputAction;
    final int maxLines;
    final int minLines;
    final bool obscureText;
    final bool readOnly;

    // Styling
    final TextStyle? labelStyle;
    final TextStyle? hintStyle;
    final TextStyle? inputStyle;
    final TextStyle? errorStyle;
    final Color? fillColor;
    final Color? borderColor;
    final Color? focusedBorderColor;
    final Color? errorBorderColor;
    final double borderRadius;
    final double borderWidth;

    // Icons & Suffixes
    final IconData? prefixIcon;
    final Widget? prefixWidget;
    final IconData? suffixIcon;
    final Widget? suffixWidget;
    final VoidCallback? suffixIconOnPressed;
    final Color? iconColor;

    // Content Padding
    final EdgeInsets contentPadding;

    // Size Control (NEW)
    final double? width;
    final double? height;

    // Callbacks
    final Function(String)? onChanged;
    final Function(String)? onSubmitted;
    final VoidCallback? onTap;

    // Input Formatters
    final List<TextInputFormatter>? inputFormatters;

    // Additional Options
    final bool showCharacterCount;
    final bool autoFocus;
    final String? counterText;
    final bool enabled;

    // Error Messages (Bilingual)
    final String? errorMessageRequiredEn;
    final String? errorMessageRequiredAr;
    final String? errorMessageEmailEn;
    final String? errorMessageEmailAr;
    final String? errorMessagePhoneEn;
    final String? errorMessagePhoneAr;
    final String? errorMessagePasswordEn;
    final String? errorMessagePasswordAr;
    final String? errorMessageNumberEn;
    final String? errorMessageNumberAr;
    final String? errorMessageAlphanumericEn;
    final String? errorMessageAlphanumericAr;
    final String? errorMessageUrlEn;
    final String? errorMessageUrlAr;
    final String? errorMessageCreditCardEn;
    final String? errorMessageCreditCardAr;
    final String? errorMessageMinLengthEn;
    final String? errorMessageMinLengthAr;
    final String? errorMessageMaxLengthEn;
    final String? errorMessageMaxLengthAr;

    const CustomKnowticedTextField({
      Key? key,
      required this.labelEn,
      required this.labelAr,
      required this.hintEn,
      required this.hintAr,
      required this.controller,
      this.focusNode,
      this.language = AppLanguage.english,
      this.textDirection,
      this.validationType = ValidationType.none,
      this.customValidator,
      this.isRequired = false,
      this.minLength,
      this.maxLength,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.done,
      this.maxLines = 1,
      this.minLines = 1,
      this.obscureText = false,
      this.readOnly = false,
      this.labelStyle,
      this.hintStyle,
      this.inputStyle,
      this.errorStyle,
      this.fillColor,
      this.borderColor,
      this.focusedBorderColor,
      this.errorBorderColor,
      this.borderRadius = 8,
      this.borderWidth = 1.5,
      this.prefixIcon,
      this.prefixWidget,
      this.suffixIcon,
      this.suffixWidget,
      this.suffixIconOnPressed,
      this.iconColor,
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      this.width,
      this.height,
      this.onChanged,
      this.onSubmitted,
      this.onTap,
      this.inputFormatters,
      this.showCharacterCount = false,
      this.autoFocus = false,
      this.counterText,
      this.enabled = true,
      // Error Messages
      this.errorMessageRequiredEn,
      this.errorMessageRequiredAr,
      this.errorMessageEmailEn,
      this.errorMessageEmailAr,
      this.errorMessagePhoneEn,
      this.errorMessagePhoneAr,
      this.errorMessagePasswordEn,
      this.errorMessagePasswordAr,
      this.errorMessageNumberEn,
      this.errorMessageNumberAr,
      this.errorMessageAlphanumericEn,
      this.errorMessageAlphanumericAr,
      this.errorMessageUrlEn,
      this.errorMessageUrlAr,
      this.errorMessageCreditCardEn,
      this.errorMessageCreditCardAr,
      this.errorMessageMinLengthEn,
      this.errorMessageMinLengthAr,
      this.errorMessageMaxLengthEn,
      this.errorMessageMaxLengthAr,
    }) : super(key: key);

    @override
    State<CustomKnowticedTextField> createState() =>
        _CustomKnowticedTextFieldState();
  }

  class _CustomKnowticedTextFieldState extends State<CustomKnowticedTextField> {
    late FocusNode _focusNode;
    late bool _obscurePassword;
    String? _errorMessage;

    @override
    void initState() {
      super.initState();
      _focusNode = widget.focusNode ?? FocusNode();
      _obscurePassword = widget.obscureText;
    }

    @override
    void dispose() {
      if (widget.focusNode == null) {
        _focusNode.dispose();
      }
      super.dispose();
    }

    /// Get label based on language
    String get _label {
      return widget.language == AppLanguage.english ? widget.labelEn : widget.labelAr;
    }

    /// Get hint based on language
    String get _hint {
      return widget.language == AppLanguage.english ? widget.hintEn : widget.hintAr;
    }

    /// Get text direction based on language
    TextDirection get _textDirection {
      if (widget.textDirection != null) return widget.textDirection!;
      return widget.language == AppLanguage.english ? TextDirection.ltr : TextDirection.rtl;
    }

    /// Get error message based on language
    String _getErrorMessage(String defaultMessageEn, String defaultMessageAr, String? customEn, String? customAr) {
      if (widget.language == AppLanguage.english) {
        return customEn ?? defaultMessageEn;
      } else {
        return customAr ?? defaultMessageAr;
      }
    }

    /// Validate input based on validation type
    String? _validateInput(String? value) {
      final text = value?.trim() ?? '';

      // Check if required
      if (widget.isRequired && text.isEmpty) {
        return _getErrorMessage(
          '${widget.labelEn} is required',
          'حقل ${widget.labelAr} مطلوب',
          widget.errorMessageRequiredEn,
          widget.errorMessageRequiredAr,
        );
      }

      if (text.isEmpty) {
        return null;
      }

      // Min length validation
      if (widget.minLength != null && text.length < widget.minLength!) {
        return _getErrorMessage(
          '${widget.labelEn} must be at least ${widget.minLength} characters',
          'يجب أن يكون ${widget.labelAr} على الأقل ${widget.minLength} أحرف',
          widget.errorMessageMinLengthEn,
          widget.errorMessageMinLengthAr,
        );
      }

      // Max length validation
      if (widget.maxLength != null && text.length > widget.maxLength!) {
        return _getErrorMessage(
          '${widget.labelEn} cannot exceed ${widget.maxLength} characters',
          'لا يمكن أن يتجاوز ${widget.labelAr} ${widget.maxLength} أحرف',
          widget.errorMessageMaxLengthEn,
          widget.errorMessageMaxLengthAr,
        );
      }

      // Type-specific validations
      switch (widget.validationType) {
        case ValidationType.email:
          if (!_isValidEmail(text)) {
            return _getErrorMessage(
              'Please enter a valid email address',
              'يرجى إدخال عنوان بريد إلكتروني صحيح',
              widget.errorMessageEmailEn,
              widget.errorMessageEmailAr,
            );
          }
          break;

        case ValidationType.phone:
          if (!_isValidPhone(text)) {
            return _getErrorMessage(
              'Please enter a valid phone number',
              'يرجى إدخال رقم هاتف صحيح',
              widget.errorMessagePhoneEn,
              widget.errorMessagePhoneAr,
            );
          }
          break;

        case ValidationType.password:
          if (!_isValidPassword(text)) {
            return _getErrorMessage(
              'Password must be at least 8 characters with uppercase, lowercase, and number',
              'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل مع أحرف كبيرة وصغيرة ورقم',
              widget.errorMessagePasswordEn,
              widget.errorMessagePasswordAr,
            );
          }
          break;

        case ValidationType.number:
          if (!_isValidNumber(text)) {
            return _getErrorMessage(
              'Please enter a valid number',
              'يرجى إدخال رقم صحيح',
              widget.errorMessageNumberEn,
              widget.errorMessageNumberAr,
            );
          }
          break;

        case ValidationType.alphanumeric:
          if (!_isValidAlphanumeric(text)) {
            return _getErrorMessage(
              'Only letters and numbers allowed',
              'يُسمح فقط بالأحرف والأرقام',
              widget.errorMessageAlphanumericEn,
              widget.errorMessageAlphanumericAr,
            );
          }
          break;

        case ValidationType.url:
          if (!_isValidUrl(text)) {
            return _getErrorMessage(
              'Please enter a valid URL',
              'يرجى إدخال عنوان URL صحيح',
              widget.errorMessageUrlEn,
              widget.errorMessageUrlAr,
            );
          }
          break;

        case ValidationType.creditCard:
          if (!_isValidCreditCard(text)) {
            return _getErrorMessage(
              'Please enter a valid credit card number',
              'يرجى إدخال رقم بطاقة ائتمان صحيح',
              widget.errorMessageCreditCardEn,
              widget.errorMessageCreditCardAr,
            );
          }
          break;

        case ValidationType.custom:
          if (widget.customValidator != null) {
            return widget.customValidator!(text);
          }
          break;

        case ValidationType.none:
        case ValidationType.required:
        case ValidationType.minLength:
        case ValidationType.maxLength:
          break;
      }

      return null;
    }

    /// Email validation
    bool _isValidEmail(String email) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      return emailRegex.hasMatch(email);
    }

    /// Phone validation (supports multiple formats)
    bool _isValidPhone(String phone) {
      final phoneRegex = RegExp(r'^[+]?[(]?[0-9]{1,4}[)]?[-\s.]?[(]?[0-9]{1,4}[)]?[-\s.]?[0-9]{1,9}$');
      return phoneRegex.hasMatch(phone);
    }

    /// Password validation (min 8 chars, uppercase, lowercase, number)
    bool _isValidPassword(String password) {
      final passwordRegex = RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
      );
      return passwordRegex.hasMatch(password);
    }

    /// Number validation
    bool _isValidNumber(String number) {
      return num.tryParse(number) != null;
    }

    /// Alphanumeric validation
    bool _isValidAlphanumeric(String text) {
      final alphanumericRegex = RegExp(r'^[a-zA-Z0-9]+$');
      return alphanumericRegex.hasMatch(text);
    }

    /// URL validation
    bool _isValidUrl(String url) {
      final urlRegex = RegExp(
        r'^(https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
      );
      return urlRegex.hasMatch(url);
    }

    /// Credit card validation (Luhn algorithm)
    bool _isValidCreditCard(String cardNumber) {
      final digits = cardNumber.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 13 || digits.length > 19) return false;

      int sum = 0;
      bool alternate = false;

      for (int i = digits.length - 1; i >= 0; i--) {
        int digit = int.parse(digits[i]);

        if (alternate) {
          digit *= 2;
          if (digit > 9) {
            digit -= 9;
          }
        }

        sum += digit;
        alternate = !alternate;
      }

      return (sum % 10 == 0);
    }

    @override
    Widget build(BuildContext context) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Directionality(
          textDirection: _textDirection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Label
              if (_label.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 3.h),
                  child: RichText(
                    textDirection: _textDirection,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _label,
                          style: widget.labelStyle ??
                              TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                        ),

                      ],
                    ),
                  ),
                ),
              // Text Form Field
              Flexible(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      selectionColor: AppColors.primary.withOpacity(0.3),
                      cursorColor: AppColors.primary,
                      selectionHandleColor: AppColors.primary,
                    ),
                  ),
                  child: TextFormField(
                    controller: widget.controller,
                    focusNode: _focusNode,
                    cursorColor: AppColors.primary,
                    textDirection: _textDirection,
                    obscureText: widget.obscureText && _obscurePassword,
                    readOnly: widget.readOnly,
                    enabled: widget.enabled,
                    maxLines: widget.obscureText ? 1 : widget.maxLines,
                    minLines: widget.obscureText ? 1 : widget.minLines,
                    keyboardType: widget.keyboardType,
                    textInputAction: widget.textInputAction,
                    autofocus: widget.autoFocus,
                    inputFormatters: widget.inputFormatters,
                    onChanged: (value) {
                      setState(() {
                        _errorMessage = _validateInput(value);
                      });
                      widget.onChanged?.call(value);
                    },
                    onFieldSubmitted: widget.onSubmitted,
                    onTap: widget.onTap,
                    validator: _validateInput,
                    style: widget.inputStyle ??
                        StyleText.fontSize16Weight500.copyWith(
                            color: AppColors.text),
                    decoration: InputDecoration(
                      hintText: _hint,
                      hintTextDirection: _textDirection,
                      hintStyle: widget.hintStyle ??
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[400],
                          ),
                      filled: true,
                      fillColor: widget.fillColor ?? Colors.grey[50],
                      contentPadding: widget.contentPadding,
                      counterText: widget.showCharacterCount ? null : '',
                      errorText: _errorMessage,
                      errorStyle: widget.errorStyle ??
                          TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.red[600],
                          ),
                      prefixIcon: widget.prefixWidget ??
                          (widget.prefixIcon != null
                              ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: SvgPicture.asset(
                              "assets/images/search_icon.svg",
                              width: 20.w,
                              height: 20.h,
                            ),
                          )
                              : null),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 20.h,
                      ),
                      suffixIcon: widget.suffixWidget ??
                          (widget.suffixIcon != null
                              ? InkWell(
                            onTap: widget.suffixIconOnPressed,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                              child: Icon(
                                widget.suffixIcon,
                                color: widget.iconColor ?? Colors.grey[600],
                                size: 20.r,
                              ),
                            ),
                          )
                              : null),
                      suffixIconConstraints: BoxConstraints(
                        minWidth: 40.w,
                        minHeight: 20.h,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius.r),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.grey[300]!,
                          width: widget.borderWidth,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius.r),
                        borderSide: BorderSide(
                          color: widget.borderColor ?? Colors.grey[300]!,
                          width: widget.borderWidth,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius.r),
                        borderSide: BorderSide(
                          color: widget.focusedBorderColor ?? AppColors.primary, // ✅ fixed too
                          width: widget.borderWidth,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius.r),
                        borderSide: BorderSide(
                          color:  Colors.red[600]!,
                          width: widget.borderWidth,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.borderRadius.r),
                        borderSide: BorderSide(
                          color: widget.errorBorderColor ?? Colors.red[600]!,
                          width: widget.borderWidth,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Character Count
              if (widget.showCharacterCount && widget.maxLength != null)
                Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Align(
                    alignment: _textDirection == TextDirection.rtl
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Text(
                      '${widget.controller.text.length}/${widget.maxLength}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
  }