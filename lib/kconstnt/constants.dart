import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../FireStoreHelper/FireStoreHelper.dart';

const kPrimaryColor = Color(0xff3c6EAE);
const kSecondaryColor = Color(0xFF35C8D0); // A bright cyan color
const kDarkColor = Color(0xFF1D7B82); // A deeper teal color
const kBodyTextColor = Color(0xFF333333); // Dark gray
const kBgColor = Color(0xFFF2F8F9); // Light cyan-tinted white
bool? issignedin   ;
const kDefaultPadding = 20.0;

int numberofApply = FireStoreHelper ().numberofApply ??0 ;
