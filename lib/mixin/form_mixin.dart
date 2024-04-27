
import 'package:flutter/cupertino.dart';

mixin FormMixin {

  /// checks if any fields are empty
  String? isRequired(String? value){
    if(value == null || value == ''){
      return 'This field is required';
    }
    return null;
  }

  /// Validates the required fields and calls a save method on the form
  bool validateAndSaveOnSubmit(BuildContext ctx) {
    final form = Form.of(ctx);

    if(!form.validate()){
      return false;
    }

    form.save();
    return true;

  }

}