import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_robo_cash/bloc/robo_cash_bloc.dart';

import 'bar_custom_painter.dart';
import '../data/depth_datasource.dart';
import '../core/settings.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 400,
    ),
  );

  List<DepthEntry> getAnimateDate(RoboCashInitial state) {
    List<DepthEntry> res = [];
    List<DepthEntry> previousData = state.previousData.isEmpty
        ? List.generate(
            state.currentData.length,
            (index) => DepthEntry(0.0, 0.0, state.currentData[index].type),
          )
        : state.previousData;

    for (var i = 0; i < state.currentData.length; i++) {
      final value1 = previousData[i];
      final value2 = state.currentData[i];

      final element = DepthEntry(
        value1.price,
        Tween<double>(begin: value1.volume, end: value2.volume)
            .animate(
              CurvedAnimation(
                parent: _controller,
                curve: Curves.bounceOut,
              ),
            )
            .value,
        value1.type,
      );
      res.add(element);
    }

    return res;
  }

  Stack _buildContent(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BlocConsumer<RoboCashBloc, RoboCashState>(
          buildWhen: (previous, current) => current is RoboCashInitial,
          listener: (context, state) {
            if (state is RoboCashInitial) {
              _controller.reset();
              _controller.forward();
            }
          },
          builder: (context, state) {
            return state is RoboCashInitial ? _buildBars(state: state) : _buildBars();
          },
        ),
        BlocBuilder<RoboCashBloc, RoboCashState>(
          builder: (context, state) {
            return state is RoboCashLoadingState ? _buildIndicator() : const SizedBox.shrink();
          },
        ),
        _buildUpdateBtn(context),
        _buildTitle()
      ],
    );
  }

  Widget _buildTitle() {
    return const Positioned.fill(
      top: 25,
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          'SIMPLE ROBO CASH',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return const Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Center(child: CircularProgressIndicator(color: btnColor)),
      ),
    );
  }

  Widget _buildUpdateBtn(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor,
            minimumSize: const Size(50, 50),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
          ),
          onPressed: () {
            final bloc = context.read<RoboCashBloc>();
            bloc.add(RoboCashLoadEvent());
          },
          child: const Text(
            'UPDATE',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildBars({RoboCashInitial? state}) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return CustomPaint(
            painter: BarCustomPainter(
              data: state != null ? getAnimateDate(state) : [],
              animationValue: TweenSequence(<TweenSequenceItem<double>>[
                TweenSequenceItem<double>(tween: Tween(begin: 1, end: 0.2), weight: 30),
                TweenSequenceItem<double>(tween: Tween(begin: 0.2, end: 0.6), weight: 30),
                TweenSequenceItem<double>(tween: Tween(begin: 0.6, end: 1), weight: 30),
              ]).animate(_controller).value,
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildContent(context)));
  }
}
