import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../../Helpers/APIHelper/Apihelper.dart';
import '../JobsModel/JobsModel.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
     List<Job> JobModels =[];
  Future<List<Job>?> getJobs ()
  async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData();
      if (response.statusCode == 200)
    {
      JobModels = (response.data as List ).skip(1).map((e) => Job.fromJson(e)).toList();
      return JobModels;
    }
      emit(SuccessState());

    }catch (e){
      emit(FailedState(e.toString()));
    }
    return null;

  }

  Future<List<Job>?> getSearchJobs(String positionName) async {
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData();
      if (response.statusCode == 200) {
        final List<Job> searchResults = (response.data as List).skip(1).where((e) => e['position'].toString().contains(positionName)) // Example condition
            .map((e) => Job.fromJson(e))
            .toList();
        emit(SuccessState());
        return searchResults;
      }
    } catch (e) {
      emit(FailedState(e.toString()));
    }
    return null;
  }


  Future<List<Job>?> getJobsAndSetBanners ()
  async{
    emit(LoadingState());
    try {
      final response = await ApiHelper.getData();
      if (response.statusCode == 200)
      {
        JobModels = (response.data as List).skip(10).map((e) => Job.fromJson(e)).toList();
        return JobModels;
      }
      emit(SuccessState());

    }catch (e){
      emit(FailedState(e.toString()));
    }
    return null;

  }
















  void showNotification(RemoteMessage message) {
    emit(SuccessNotoficationState(
        message.notification!.title??"",  // Title of the notification
        message.notification!.body??"",   // Body of the notification
        message                       // The full RemoteMessage object
    ));
  }






  Map<String, Color> tagColors = {
    "All": Colors.white,
    "Software": Colors.white,
    "Design": Colors.white,
    "Management": Colors.white,
    "Developer": Colors.white,
    "Security": Colors.white,
    "Senior": Colors.white,
  };



  void changecolor(String tag) {
    tagColors.updateAll((key, value) => Colors.white);

    tagColors[tag] = tagColors[tag] == Colors.white ? const Color(0xff3c6EAE): Colors.white;
    emit(ColorChangedState());
  }

  final Color _currentColor = Colors.grey; // اللون الافتراضي

  bool changeColor( int index, Color newColor) {
    if ( JobModels[index].savedColor == Colors.grey){
      JobModels[index].savedColor = newColor;
      emit(ColorChangedState());
      return true;
    }
    JobModels[index].savedColor = newColor;

    emit(ColorChangedState());
    return false;

  }
  Color get currentColor => _currentColor;
  List<Job> getjobs (){
    return JobModels;
  }
}
