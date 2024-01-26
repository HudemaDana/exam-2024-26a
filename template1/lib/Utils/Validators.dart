import 'package:flutter/src/widgets/framework.dart';
import 'package:path/path.dart';

import 'Message.dart';

void validateInput(BuildContext context,String s1, String s2, String s3, String s4, int i1, String i2){
  if (s1.isEmpty) {
    message(context, 'Name is required', "Error");
  } else if (s2.isEmpty) {
    message(context, 'Team is required', "Error");
  } else if (s3.isEmpty) {
    message(context, 'Details is required', "Error");
  } else if (s4.isEmpty) {
    message(context, 'Status is required', "Error");
  } else if (i1 == null) {
    message(context, 'Members must be an integer', "Error");
  } else if (i2.isEmpty) {
    message(context, 'Type must be a double', "Error");
  }
}