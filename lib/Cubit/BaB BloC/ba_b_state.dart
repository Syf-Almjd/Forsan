part of 'ba_b_bloc.dart';

@immutable
abstract class BaBState {
  final int defaultIndex;

  const BaBState(this.defaultIndex);
}

class BaBInitial extends BaBState {
  const BaBInitial(super.defaultIndex);
}

class HomeScreen extends BaBState {
  const HomeScreen(super.defaultIndex);
}

class ProductScreen extends BaBState {
  const ProductScreen(super.defaultIndex);
}

class CartScreen extends BaBState {
  const CartScreen(super.defaultIndex);
}

class ProfileScreen extends BaBState {
  const ProfileScreen(super.defaultIndex);
}

// class CurrentIndex extends BaBState {}


//Registration Page

@immutable
abstract class RegisterPagesState {
  final int defaultIndex;
  const RegisterPagesState(this.defaultIndex);
}

class RegisterPagesInitial extends RegisterPagesState {
  const RegisterPagesInitial(super.defaultIndex);
}

class LoginScreen extends RegisterPagesState {
  const LoginScreen(super.defaultIndex);
}

class RegisterScreenOne extends RegisterPagesState {
  const RegisterScreenOne(super.defaultIndex);
}

class RegisterScreenTwo extends RegisterPagesState {
  const RegisterScreenTwo(super.defaultIndex);
}

class RegisterScreenThree extends RegisterPagesState {
  const RegisterScreenThree(super.defaultIndex);
}
