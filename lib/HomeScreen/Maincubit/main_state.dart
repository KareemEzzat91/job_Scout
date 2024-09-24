part of 'main_cubit.dart';

@immutable
sealed class MainState {}
final class SavedChanger extends MainState {}
final class MainInitial extends MainState {}
final class LoadingState extends MainState {}
final class SuccessState extends MainState {}
final class SuccessNotoficationState extends MainState {
  final String msg;
  final String details;
  final RemoteMessage message;

  SuccessNotoficationState(this.msg, this.details, this.message);
}
final class FailedState extends MainState {
  final String error ;

  FailedState(this.error);
}
