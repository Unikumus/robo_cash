part of 'robo_cash_bloc.dart';

abstract class RoboCashState extends Equatable {
  const RoboCashState();
}

class RoboCashEmptyState extends RoboCashState {
  @override
  List<Object?> get props => [];
}

class RoboCashLoadingState extends RoboCashState {
  @override
  List<Object?> get props => [];
}

class RoboCashInitial extends RoboCashState {
  final List<DepthEntry> currentData;
  final List<DepthEntry> previousData;

  @override
  List<Object> get props => [
        currentData,
        previousData,
      ];

  const RoboCashInitial({
    required this.currentData,
    required this.previousData,
  });
}
