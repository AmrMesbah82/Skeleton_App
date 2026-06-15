import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:demo_app/core/theme/app_colors.dart';
import '../theme/app_colors.dart';

/// Custom text field widget — mirrors CustomDropdown API exactly.
///
/// Border rule: NO border by default; red border only when [errorText] is set.
class CustomTextField extends StatefulWidget {
  // ── Controller / Focus ───────────────────────────────────────────────────

  /// Text editing controller. If null an internal one is created.
  final TextEditingController? controller;

  /// Focus node. If null an internal one is created.
  final FocusNode? focusNode;

  // ── Content ──────────────────────────────────────────────────────────────

  /// Initial value (only used when [controller] is null).
  final String? initialValue;

  /// Placeholder text.
  final String? hint;

  /// Label displayed above the field.
  final String? label;

  /// Error message — also triggers the red border.
  final String? errorText;

  /// Helper text displayed below the field.
  final String? helperText;

  // ── Icons ────────────────────────────────────────────────────────────────

  /// Widget shown at the start of the field.
  final Widget? prefixIcon;

  /// Widget shown at the end of the field (overrides the password-toggle eye).
  final Widget? suffixIcon;

  // ── Behaviour ────────────────────────────────────────────────────────────

  /// Whether the field is interactive.
  final bool enabled;

  /// Whether the field is read-only (tappable but not editable).
  final bool readOnly;

  /// Adds a red " *" to the label.
  final bool required;

  /// Hides text (password mode). Shows an eye-toggle unless [suffixIcon] is
  /// provided.
  final bool obscureText;

  /// Maximum number of lines. 1 = single-line (default). null = unlimited.
  final int? maxLines;

  /// Minimum number of lines for multiline fields.
  final int? minLines;

  /// Hard character limit. Shows a counter when set.
  final int? maxLength;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Input formatters (e.g. digits-only).
  final List<TextInputFormatter>? inputFormatters;

  /// Text alignment inside the field.
  final TextAlign textAlign;

  /// Text direction (useful for RTL/LTR mixed content).
  final TextDirection? textDirection;

  /// Action button on the keyboard.
  final TextInputAction? textInputAction;

  /// Auto-capitalisation strategy.
  final TextCapitalization textCapitalization;

  /// Whether to enable autocorrect.
  final bool autocorrect;

  /// Whether to show text-suggestions.
  final bool enableSuggestions;

  // ── Callbacks ────────────────────────────────────────────────────────────

  /// Called on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits (presses the keyboard action button).
  final ValueChanged<String>? onSubmitted;

  /// Called when the field gains or loses focus.
  final ValueChanged<bool>? onFocusChanged;

  /// Called when the field is tapped (useful when [readOnly] is true).
  final VoidCallback? onTap;

  // ── Appearance ───────────────────────────────────────────────────────────

  /// Background fill color.
  final Color? fillColor;

  /// Border radius — defaults to 8.r internally.
  final BorderRadius? borderRadius;

  /// Padding inside the field container.
  final EdgeInsetsGeometry? contentPadding;

  // ── Text styles ──────────────────────────────────────────────────────────

  final TextStyle? valueStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final TextStyle? helperStyle;
  final TextStyle? counterStyle;

  const CustomTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.hint,
    this.label,
    this.errorText,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.onChanged,
    this.onSubmitted,
    this.onFocusChanged,
    this.onTap,
    this.fillColor,
    this.borderRadius,
    this.contentPadding,
    this.valueStyle,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.helperStyle,
    this.counterStyle,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _obscured = true; // tracks password visibility toggle

  // Live character count (only needed when maxLength is set)
  int _charCount = 0;

  @override
  void initState() {
    super.initState();

    // Controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }

    // Focus node
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _focusNode.addListener(_onFocusChange);

    if (widget.maxLength != null) {
      _charCount = _controller.text.length;
      _controller.addListener(_onTextChange);
    }
  }

  void _onFocusChange() {
    setState(() {}); // rebuild so suffix eye-icon tint can update if needed
    widget.onFocusChanged?.call(_focusNode.hasFocus);
  }

  void _onTextChange() {
    if (widget.maxLength != null) {
      setState(() => _charCount = _controller.text.length);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (_ownsFocusNode) _focusNode.dispose();
    if (widget.maxLength != null) _controller.removeListener(_onTextChange);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  bool get _isMultiline => (widget.maxLines ?? 1) != 1 || widget.minLines != null;

  // Effective obscure: only applies when the prop is true AND not multiline
  bool get _effectiveObscure =>
      widget.obscureText && !_isMultiline && _obscured;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;
    final radius = widget.borderRadius ?? BorderRadius.circular(8.r);
    final isDisabled = !widget.enabled;

    // ── Suffix icon resolution ─────────────────────────────────────────────
    // Priority: explicit suffixIcon > password-toggle eye > nothing
    Widget? resolvedSuffix = widget.suffixIcon;
    if (resolvedSuffix == null && widget.obscureText && !_isMultiline) {
      resolvedSuffix = GestureDetector(
        onTap: () => setState(() => _obscured = !_obscured),
        child: Icon(
          _obscured
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 20.sp,
          color: hasError
              ? AppColors.red
              : isDisabled
              ? AppColors.text.withOpacity(0.3)
              : AppColors.text.withOpacity(0.5),
        ),
      );
    }

    // ── Content padding ────────────────────────────────────────────────────
    final effectivePadding = widget.contentPadding ??
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ──────────────────────────────────────────────────────────
        if (widget.label != null) ...[
          RichText(
            text: TextSpan(
              text: widget.label,
              style: widget.labelStyle ??
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: hasError
                        ? AppColors.red
                        : isDisabled
                        ? AppColors.text.withOpacity(0.4)
                        : AppColors.text,
                  ),
              children: widget.required
                  ? [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: AppColors.red),
                ),
              ]
                  : [],
            ),
          ),
          SizedBox(height: 6.h),
        ],

        // ── Field ──────────────────────────────────────────────────────────
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: _effectiveObscure,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          keyboardType: _isMultiline
              ? TextInputType.multiline
              : widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autocorrect: widget.autocorrect,
          enableSuggestions: widget.enableSuggestions,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          style: widget.valueStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: isDisabled
                    ? AppColors.text.withOpacity(0.4)
                    : AppColors.text,
              ),
          // Hide the built-in counter — we render our own below
          buildCounter: widget.maxLength != null
              ? (_, {required currentLength, required isFocused, maxLength}) =>
          const SizedBox.shrink()
              : null,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: effectivePadding,
            filled: true,
            fillColor: isDisabled
                ? (widget.fillColor ?? AppColors.card).withOpacity(0.5)
                : widget.fillColor ?? AppColors.card,

            // ── No border rule ────────────────────────────────────────────
            // Default / focused / disabled → no border at all.
            // Error → red border.
            border: hasError
                ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
            )
                : OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            enabledBorder: hasError
                ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
            )
                : OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            focusedBorder: hasError
                ? OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
            )
                : OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius,
              borderSide: BorderSide(color: AppColors.red, width: 1.5.w),
            ),
            // ─────────────────────────────────────────────────────────────

            hintText: widget.hint,
            hintStyle: widget.hintStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.text.withOpacity(0.4),
                ),

            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: EdgeInsets.only(left: 12.w, right: 8.w),
              child: widget.prefixIcon,
            )
                : null,
            prefixIconConstraints: const BoxConstraints(),

            suffixIcon: resolvedSuffix != null
                ? Padding(
              padding: EdgeInsets.only(left: 8.w, right: 12.w),
              child: resolvedSuffix,
            )
                : null,
            suffixIconConstraints: const BoxConstraints(),

            // Suppress built-in error / helper — we render our own
            errorText: null,
            helperText: null,
            counterText: '',
          ),
        ),

        // ── Error / Helper / Counter row ───────────────────────────────────
        if (hasError || widget.helperText != null || widget.maxLength != null) ...[
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: error or helper
              Expanded(
                child: hasError
                    ? Text(
                  widget.errorText!,
                  style: widget.errorStyle ??
                      TextStyle(fontSize: 12.sp, color: AppColors.red),
                )
                    : widget.helperText != null
                    ? Text(
                  widget.helperText!,
                  style: widget.helperStyle ??
                      TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.text.withOpacity(0.5),
                      ),
                )
                    : const SizedBox.shrink(),
              ),

              // Right: character counter
              if (widget.maxLength != null) ...[
                SizedBox(width: 8.w),
                Text(
                  '$_charCount / ${widget.maxLength}',
                  style: widget.counterStyle ??
                      TextStyle(
                        fontSize: 12.sp,
                        color: _charCount > widget.maxLength!
                            ? AppColors.red
                            : AppColors.text.withOpacity(0.4),
                      ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Usage examples
// ─────────────────────────────────────────────────────────────────────────────

/*
// ── Simple text ──────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Full Name',
  hint: 'Enter your name',
  required: true,
  prefixIcon: Icon(Icons.person_outline, size: 18.sp),
  onChanged: (v) => debugPrint(v),
)

// ── Password ─────────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Password',
  hint: 'Enter password',
  required: true,
  obscureText: true,
  textInputAction: TextInputAction.done,
)

// ── Multiline ────────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Notes',
  hint: 'Write something…',
  maxLines: 5,
  minLines: 3,
  maxLength: 500,
  helperText: 'Max 500 characters',
)

// ── Read-only ────────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Email',
  controller: TextEditingController(text: 'amr@example.com'),
  readOnly: true,
  prefixIcon: Icon(Icons.email_outlined, size: 18.sp),
)

// ── Digits only ──────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Phone',
  hint: '05xxxxxxxx',
  keyboardType: TextInputType.phone,
  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  maxLength: 10,
)

// ── Error state ──────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Username',
  errorText: 'Username is already taken',
)

// ── Disabled ─────────────────────────────────────────────────────────────────
CustomTextField(
  label: 'Role',
  controller: TextEditingController(text: 'Admin'),
  enabled: false,
)
*/
