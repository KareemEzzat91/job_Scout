import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:jobscout/main.dart';
import 'package:meta/meta.dart';

import '../../APIHelper/Apihelper.dart';
import '../../Firebasenotofication/NotoficationScreen.dart';
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













  Color _currentColor = Colors.grey; // اللون الافتراضي

  void changeColor(int index, Color newColor) {
    JobModels[index].savedColor = newColor;
    emit(ColorChangedState());
  }
  Color get currentColor => _currentColor;
  List<Job> getjobs (){
    return JobModels;
  }
}
