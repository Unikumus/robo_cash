part of 'robo_cash_bloc.dart';

abstract class RoboCashEvent extends Equatable {
  const RoboCashEvent();

  @override
  List<Object> get props => [];
}

class RoboCashLoadEvent extends RoboCashEvent {}

class RoboCashUpdateEvent extends RoboCashEvent {}
