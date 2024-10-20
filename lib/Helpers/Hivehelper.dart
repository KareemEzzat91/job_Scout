import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';

class Hivehelper {

  static const String Boxname = "FirstTime";
  static const String NotoficationBoxname = "FirstTime";
  static List <RemoteMessage> messages =[];
  static void addNotofication (RemoteMessage message){
    messages.add(message);
    Hive.box(NotoficationBoxname).put(NotoficationBoxname, messages);
  }
  static Future <void> getNotes()async{
    messages = await Hive.box(NotoficationBoxname).get(NotoficationBoxname);
}


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