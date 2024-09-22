import 'package:hive/hive.dart';

class Hivehelper {

  static final String Boxname = "FirstTime";

  static void init() {
    Hive.box(Boxname).put(Boxname, true);
  }
  static void logout (){
    Hive.box(Boxname).delete(Boxname);

  }
  static bool checkfirst() {
    return Hive.box(Boxname).isEmpty;
  }

}