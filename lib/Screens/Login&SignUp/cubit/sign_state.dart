part of 'sign_cubit.dart';

@immutable
sealed class SignState {}

final class SignInitial extends SignState {}
final class SignSuccesState extends SignState {}
final class SignLoadingState extends SignState {}
final class SignFaliureState extends SignState {
  final error ;
  SignFaliureState(this.error);
}
