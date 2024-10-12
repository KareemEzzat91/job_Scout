import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../FireStoreHelper/FireStoreHelper.dart';

const kbackgroundcolor = Color(0xfff7faff);
const ksecondTextcolor = Color(0xFF333333); // A bright cyan colo
// r
final kcontainercoloe = Colors.blue.shade700;
final kactiveJobsTextcoloe = Colors.white70;
const kwhiteTextcolor = Color(0xffFFFFFFFF);

const kDarkColor = Color(0xFF1D7B82); // A deeper teal color
const kBodyTextColor = Color(0xFF333333); // Dark gray
const kBgColor = Color(0xFFF2F8F9); // Light cyan-tinted white
bool? issignedin   ;
const kDefaultPadding = 20.0;

int numberofApply = FireStoreHelper ().numberofApply ??0 ;
pickImage(ImageSource source)async{
  final ImagePicker  _imagepicker= ImagePicker();
  XFile ?_file= await _imagepicker.pickImage(source: source);
  if (_file != null){
    return await _file.readAsBytes();
  }
  print("no image selected");
}