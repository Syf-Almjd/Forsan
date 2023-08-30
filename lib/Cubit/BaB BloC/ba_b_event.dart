part of 'ba_b_bloc.dart';

@immutable
abstract class BaBEvent {}

class TabChange extends BaBEvent {
  final int currentIndex;

  TabChange(this.currentIndex);
}

@immutable
abstract class RegisterTabEvent {}

class RegisterTabChange extends RegisterTabEvent {
  final int currentIndex;

  RegisterTabChange(this.currentIndex);
}
