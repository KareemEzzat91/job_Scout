import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FireStoreHelper/FireStoreHelper.dart';
// ألوان الوضع الفاتح
const kLightBackgroundColor = Color(0xfff7faff);
const kLightSecondTextColor = Color(0xFF333333);
final kLightContainerColor = Colors.blue.shade700;
const kLightActiveJobsTextColor = Colors.white70;
const kLightWhiteTextColor = Color(0xffffffff);
const kLightBodyTextColor = Color(0xFF333333); // Dark gray
const kLightBgColor = Color(0xFFF2F8F9); // Light cyan-tinted white

// ألوان الوضع الداكن
const kDarkBackgroundColor = Color(0xFF1D1D1D); // Color for dark mode background
const kDarkSecondTextColor = Color(0xFFFFFFFF); // White for dark mode
final kDarkContainerColor = Colors.blue.shade900; // Darker shade for containers
const kDarkActiveJobsTextColor = Color(0xFFAAAAAA); // Light gray for active jobs text
const kDarkBodyTextColor = Color(0xFFE0E0E0); // Lighter gray for body text
const kDarkBgColor = Color(0xFF121212); // Dark background color


int numberofApply = FireStoreHelper ().numberofApply ??0 ;
pickImage(ImageSource source)async{
  final ImagePicker  imagepicker= ImagePicker();
  XFile ?file= await imagepicker.pickImage(source: source);
  if (file != null){
    return await file.readAsBytes();
  }
  ("no image selected");
}