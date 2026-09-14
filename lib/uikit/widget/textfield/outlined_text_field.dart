import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../token/index.dart';

class OutlinedTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isError;
  final bool isEnable;
  final String? errorText;
  final String? helperText;
  final Function? onPrefixIconTap;
  final Function? onSuffixIconTap;
  final Function(String)? onTextChanged;
  final TextCapitalization? textCapitalization;

  const OutlinedTextField({
    super.key,
    this.controller,
    this.textInputType,
    this.textInputAction,
    this.focusNode,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.onTextChanged,
    this.errorText,
    this.helperText,
    this.isPassword = false,
    this.isError = false,
    this.isEnable = true,
    this.textCapitalization,
  });

  @override
  State<OutlinedTextField> createState() => _OutlinedTextFieldState();
}

class _OutlinedTextFieldState extends State<OutlinedTextField> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late bool _ownsController;
  late bool _ownsFocusNode;
  bool _isFocussedOrFilled = false;
  bool _isPassword = false;
  bool _obscureText = false;

  InputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: BorderSide(
        color: widget.isError ? AppColor.error : AppColor.neutralAlt,
        width: AppDimension.borderWidth,
      ),
    );
  }

  InputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: const BorderSide(
        color: AppColor.error,
        width: AppDimension.borderWidth,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isPassword = widget.isPassword;
    _obscureText = _isPassword;

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
      _focusNode.addListener(_onFocusChangedListener);
    }
  }

  void _onFocusChangedListener() {
    setState(() {
      _isFocussedOrFilled = _focusNode.hasFocus || _controller.text.isNotEmpty;
    });
  }

  @override
  void didUpdateWidget(covariant OutlinedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword) {
      _isPassword = widget.isPassword;
      _obscureText = widget.isPassword;
    }
    if (!identical(oldWidget.controller, widget.controller)) {
      _controller = widget.controller ?? TextEditingController();
      _ownsController = widget.controller == null;
      _isFocussedOrFilled = _focusNode.hasFocus || _controller.text.isNotEmpty;
    }
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.removeListener(_onFocusChangedListener);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onTextChanged,
      enabled: widget.isEnable,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.textInputType,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? (widget.maxLines ?? 1) : widget.maxLines,
      minLines: widget.minLines,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      style: AppTextStyle.bodyLarge,
      // inputFormatters: [
      //   EmojiFilteringFormatter(),
      // ],
      decoration: InputDecoration(
        border: _getInputBorder(),
        filled: true,
        fillColor: widget.isError
            ? Colors.white
            : !widget.isEnable
            ? AppColor.white
            : AppColor.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing20,
          vertical: AppSpacing.spacing13,
        ),
        hintText: widget.hintText,
        hintStyle: AppTextStyle.bodyLarge,
        helperText: widget.helperText,
        helperMaxLines: 2,
        helperStyle: AppTextStyle.bodyMedium.apply(
          color: AppColor.textSecondary,
        ),
        errorMaxLines: 2,
        errorText: widget.errorText,
        errorStyle: AppTextStyle.bodyMedium.apply(color: AppColor.error),
        prefixIcon: widget.prefixIcon == null
            ? null
            : SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: () => widget.onPrefixIconTap?.call(),
                  child: Icon(
                    widget.prefixIcon,
                    color: _isFocussedOrFilled || !widget.isEnable
                        ? AppColor.neutral
                        : AppColor.neutralAlt,
                  ),
                ),
              ),
        suffixIcon: widget.isPassword
            ? SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: _togglePassword,
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: _isFocussedOrFilled
                        ? AppColor.neutral
                        : AppColor.neutralAlt,
                  ),
                ),
              )
            : widget.suffixIcon != null
            ? SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: () => widget.onSuffixIconTap?.call(),
                  child: Icon(
                    widget.suffixIcon,
                    color: _isFocussedOrFilled
                        ? AppColor.primary
                        : AppColor.primary,
                  ),
                ),
              )
            : null,
        focusedBorder: _getInputBorder(),
        enabledBorder: _getInputBorder(),
        focusedErrorBorder: _getErrorBorder(),
        errorBorder: _getErrorBorder(),
      ),
    );
  }
}

class OutlinedTextField2 extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? minLines;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isPassword;
  final bool isError;
  final bool isEnable;
  final String? errorText;
  final String? helperText;
  final Function? onPrefixIconTap;
  final Function? onSuffixIconTap;
  final Function(String)? onTextChanged;
  final TextCapitalization? textCapitalization;

  const OutlinedTextField2({
    super.key,
    this.controller,
    this.textInputType,
    this.textInputAction,
    this.focusNode,
    this.maxLines,
    this.minLines,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.onPrefixIconTap,
    this.onSuffixIconTap,
    this.onTextChanged,
    this.errorText,
    this.helperText,
    this.isPassword = false,
    this.isError = false,
    this.isEnable = true,
    this.textCapitalization,
  });

  @override
  State<OutlinedTextField2> createState() => _OutlinedTextField2State();
}

class _OutlinedTextField2State extends State<OutlinedTextField2> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late bool _ownsController;
  late bool _ownsFocusNode;
  bool _isFocussedOrFilled = false;
  bool _isPassword = false;
  bool _obscureText = false;

  InputBorder _getInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: BorderSide(
        color: widget.isError ? AppColor.error : AppColor.neutralAlt,
        width: AppDimension.borderWidth,
      ),
    );
  }

  InputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.radius10),
      borderSide: const BorderSide(
        color: AppColor.error,
        width: AppDimension.borderWidth,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _isPassword = widget.isPassword;
    _obscureText = _isPassword;

    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
      _ownsFocusNode = false;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
      _focusNode.addListener(_onFocusChangedListener);
    }
  }

  void _onFocusChangedListener() {
    setState(() {
      _isFocussedOrFilled = _focusNode.hasFocus || _controller.text.isNotEmpty;
    });
  }

  @override
  void didUpdateWidget(covariant OutlinedTextField2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPassword != widget.isPassword) {
      _isPassword = widget.isPassword;
      _obscureText = widget.isPassword;
    }
    if (!identical(oldWidget.controller, widget.controller)) {
      _controller = widget.controller ?? TextEditingController();
      _ownsController = widget.controller == null;
      _isFocussedOrFilled = _focusNode.hasFocus || _controller.text.isNotEmpty;
    }
  }

  void _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void dispose() {
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.removeListener(_onFocusChangedListener);
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onTextChanged,
      enabled: widget.isEnable,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardType: widget.textInputType,
      obscureText: _obscureText,
      maxLines: widget.isPassword ? (widget.maxLines ?? 1) : widget.maxLines,
      minLines: widget.minLines,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      style: AppTextStyle.bodyLarge,
      inputFormatters: [EmojiFilteringFormatter()],
      decoration: InputDecoration(
        border: _getInputBorder(),
        filled: true,
        fillColor: widget.isError
            ? Colors.white
            : !widget.isEnable
            ? AppColor.white
            : AppColor.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing20,
          vertical: AppSpacing.spacing13,
        ),
        hintText: widget.hintText,
        hintStyle: AppTextStyle.bodyLarge,
        helperText: widget.helperText,
        helperMaxLines: 2,
        helperStyle: AppTextStyle.bodyMedium.apply(
          color: AppColor.textSecondary,
        ),
        errorMaxLines: 2,
        errorText: widget.errorText,
        errorStyle: AppTextStyle.bodyMedium.apply(color: AppColor.error),
        prefixIcon: widget.prefixIcon == null
            ? null
            : SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: () => widget.onPrefixIconTap?.call(),
                  child: Icon(
                    widget.prefixIcon,
                    color: _isFocussedOrFilled || !widget.isEnable
                        ? AppColor.neutral
                        : AppColor.neutralAlt,
                  ),
                ),
              ),
        suffixIcon: widget.isPassword
            ? SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: _togglePassword,
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: _isFocussedOrFilled
                        ? AppColor.neutral
                        : AppColor.neutralAlt,
                  ),
                ),
              )
            : widget.suffixIcon != null
            ? SizedBox(
                width: AppDimension.icon24,
                height: AppDimension.icon24,
                child: GestureDetector(
                  onTap: () => widget.onSuffixIconTap?.call(),
                  child: Icon(
                    widget.suffixIcon,
                    color: _isFocussedOrFilled
                        ? AppColor.primary
                        : AppColor.primary,
                  ),
                ),
              )
            : null,
        focusedBorder: _getInputBorder(),
        enabledBorder: _getInputBorder(),
        focusedErrorBorder: _getErrorBorder(),
        errorBorder: _getErrorBorder(),
      ),
    );
  }
}

class EmojiFilteringFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Filter out characters that are emojis
    final filteredText = newValue.text.replaceAllMapped(
      RegExp(r'[\p{Emoji}]', unicode: true),
      (match) => '',
    );
    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
