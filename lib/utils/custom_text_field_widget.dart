import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:separated_row/separated_row.dart';
import 'package:sparkduet/core/app_functions.dart';


class CustomTextFieldWidget extends StatefulWidget {

  final String? label;
  final String? placeHolder;
  final String? initialValue;
  final bool? readOnly;
  final bool? disabled;
  final void Function()? onTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChange;
  final void Function(String?)? onSaved;
  final Widget? prefixIcon;
  final Widget? prefix;
  final Function(bool?)? onFocusChanged;
  final TextInputType? inputType;
  final bool? obscureText;
  final bool? isPassword;
  final bool? isPhone;
  final String? initialPhoneCountryCode;
  final int? maxLines;
  final int? minLines;
  final FocusNode? focusNode;
  final String? errorText;
  final Widget? suffix;
  final TextCapitalization textCapitalization;
  final bool showLabel;
  final Function(String)? onFieldSubmitted;
  final Function(CountryCode)? onCountryCodeChanged;
  final String? subLabel;
  final Color? borderColor;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final Color? placeHolderColor;
  final ValueChanged? onSubmitted;


  const CustomTextFieldWidget({super.key,
    this.borderColor,
    this.labelColor,
    this.labelFontWeight,
    this.placeHolderColor,
    this.maxLines = 1,
    this.minLines = 1,
    this.initialValue,
    this.readOnly = false,
    this.disabled = false,
    this.onTap,
    this.controller,
    this.validator,
    this.onSaved,
    this.prefixIcon,
    this.prefix,
    this.onChange,
    this.label,
    this.placeHolder,
    this.onFocusChanged,
    this.inputType = TextInputType.text,
    this.obscureText = false,
    this.isPassword = false,
    this.isPhone = false,
    this.initialPhoneCountryCode,
    this.focusNode,
    this.errorText,
    this.suffix,
    this.textCapitalization = TextCapitalization.sentences,
    this.showLabel = true,
    this.onFieldSubmitted,
    this.onCountryCodeChanged,
    this.subLabel,
    this.onSubmitted,
  });

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {

  bool _hideText = true;
  bool hasReceivedFocus = false;
  final double radius = 5;
  late CountryCode initCountryCode;

  @override
  void initState() {
    final locale = PlatformDispatcher.instance.locale;
    initCountryCode = CountryCode.fromCountryCode(widget.initialPhoneCountryCode ?? locale.countryCode ?? "US");
    onWidgetBindingComplete(onComplete: () {
        if(widget.isPhone ?? false) {
          widget.onCountryCodeChanged?.call(initCountryCode);
        }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    bool readOnly = widget.readOnly!;

    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    if(widget.disabled != null && widget.disabled!){
      readOnly = true;
    }
    final double outlineOpacity = theme.brightness == Brightness.light ? 0.5 : 1;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(widget.label != null && widget.label!.isNotEmpty && widget.showLabel) ...{
          Text(widget.label ?? '', style: TextStyle(color: widget.labelColor ?? theme.colorScheme.onBackground, fontSize: 14, fontWeight: widget.labelFontWeight ?? FontWeight.w400),),
          const SizedBox(height: 10,),
        },
        Focus(
          child: TextFormField(
            controller: widget.controller,
            keyboardType: widget.inputType,
            initialValue: widget.initialValue,
            readOnly: readOnly,
            onFieldSubmitted: widget.onSubmitted,
            focusNode: widget.focusNode,
            textCapitalization: (widget.inputType == TextInputType.emailAddress || widget.isPassword == true) ? TextCapitalization.none : widget.textCapitalization,
            onTap: widget.onTap,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            validator: widget.validator,
            obscureText:  widget.isPassword! ?_hideText : widget.obscureText!,
            onSaved:  widget.onSaved,
            onChanged: widget.onChange,
            cursorColor: widget.labelColor ?? (theme.brightness == Brightness.light ? theme.colorScheme.outline.withOpacity(0.5) : theme.colorScheme.onBackground),
            style: TextStyle(color: widget.labelColor ?? theme.colorScheme.onBackground),
            textAlign: TextAlign.left,
            decoration: InputDecoration(
                filled: true,
                errorText: widget.errorText,
                fillColor:  (widget.disabled != null && widget.disabled!)? theme.colorScheme.outline.withOpacity(0.2) : Colors.transparent,
                hintText: widget.placeHolder,
                hintStyle: TextStyle(color: widget.placeHolderColor ?? theme.colorScheme.onBackground.withOpacity(0.5)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                focusedBorder: OutlineInputBorder(
                  borderSide:  BorderSide(color: widget.borderColor ?? theme.colorScheme.outline.withOpacity(outlineOpacity), width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                border: OutlineInputBorder(
                  borderSide:  BorderSide(color: widget.borderColor ?? theme.colorScheme.outline.withOpacity(outlineOpacity), width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: widget.borderColor ?? theme.colorScheme.outline.withOpacity(outlineOpacity), width: 1),
                  borderRadius: BorderRadius.circular(radius),
                ),
                suffixIcon:  widget.isPassword! ? IconButton(onPressed: () => setState(() => _hideText = !_hideText),
                    icon: Icon(_hideText ? Icons.visibility_outlined: Icons.visibility_off_outlined)
                ) : widget.suffix ,
                prefixIcon: (widget.isPhone ?? false) ? CountryCodePicker(
                  onChanged: (CountryCode countryCode) {
                    widget.onCountryCodeChanged?.call(countryCode);
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: initCountryCode.code,
                  // favorite: const ['+1','US'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  dialogTextStyle: TextStyle(color: theme.colorScheme.onBackground),
                  dialogBackgroundColor: theme.brightness == Brightness.dark ? const Color(0xff202021) : theme.colorScheme.background,
                  showFlag: false,
                  showFlagDialog: true,
                  // backgroundColor: Colors.black,
                  barrierColor: Colors.black.withOpacity(0.9),
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  builder: (countryCode) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: IntrinsicHeight(
                        child: SeparatedRow(
                          mainAxisSize: MainAxisSize.min,
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(width: 5,);
                          },
                          children: [
                            Text(countryCode?.code ?? "", style: theme.textTheme.bodyMedium,) ,
                            Text("(${countryCode?.dialCode ?? ''})", style: theme.textTheme.bodyMedium,),
                            const Icon(Icons.keyboard_arrow_down, size: 24,),
                            Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                width: 1,
                                color: theme.colorScheme.outline.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },

                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ) : widget.prefixIcon,
                prefix:  widget.prefix,

            ),
          ),
          onFocusChange: (value) {
            setState(() {
              hasReceivedFocus = value;
              if(widget.onFocusChanged != null){
                widget.onFocusChanged!(value);
              }
            });

          },
        ),
        if(widget.subLabel != null && widget.subLabel!.isNotEmpty) ... {
          const SizedBox(height: 5,),
          Text(widget.subLabel ?? '', style: theme.textTheme.titleSmall,)
        }

      ],
    );
  }
}
