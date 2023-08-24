import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:simple_robo_cash/data/depth_data_repository.dart';
import 'package:simple_robo_cash/data/depth_datasource.dart';

part 'robo_cash_event.dart';
part 'robo_cash_state.dart';

class RoboCashBloc extends Bloc<RoboCashEvent, RoboCashState> {
  DepthDataRepository dataRepository = DepthDataRepository();

  List<DepthEntry> _currentData = [];

  RoboCashBloc() : super(RoboCashEmptyState()) {
    on<RoboCashLoadEvent>((event, emit) async {
      emit(RoboCashLoadingState());

      final data = await dataRepository.loadDate();

      emit(
        RoboCashInitial(
          currentData: data,
          previousData: _currentData,
        ),
      );
      _currentData = data;
    });
  }
}
