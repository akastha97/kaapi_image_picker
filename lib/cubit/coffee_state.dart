import 'package:equatable/equatable.dart';

abstract class CoffeeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CoffeeInitial extends CoffeeState {}

class CoffeeLoading extends CoffeeState {}

class CoffeeSuccess extends CoffeeState {
  final String imageUrl;

  CoffeeSuccess(this.imageUrl);

  @override
  List<Object?> get props => [imageUrl];
}

class CoffeeError extends CoffeeState {
  final String errorMessage;

  CoffeeError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
