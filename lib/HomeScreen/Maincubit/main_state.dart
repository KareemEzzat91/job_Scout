part of 'main_cubit.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}
final class LoadingState extends MainState {}
final class SuccessState extends MainState {}
final class FailedState extends MainState {
  final String error ;

  FailedState(this.error);
}
