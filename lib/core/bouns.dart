import 'package:flutter/cupertino.dart';

class SmoothBouncingScrollPhysics extends BouncingScrollPhysics {
  const SmoothBouncingScrollPhysics({ScrollPhysics? parent})
      : super(parent: parent);

  @override
  SmoothBouncingScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SmoothBouncingScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    // Reduce the resistance at boundaries for smoother bounce
    if (value < position.pixels &&
        position.pixels <= position.minScrollExtent) {
      return value - position.pixels;
    }
    if (position.maxScrollExtent <= position.pixels &&
        position.pixels < value) {
      return value - position.pixels;
    }
    if (value < position.minScrollExtent &&
        position.minScrollExtent < position.pixels) {
      return value - position.minScrollExtent;
    }
    if (position.pixels < position.maxScrollExtent &&
        position.maxScrollExtent < value) {
      return value - position.maxScrollExtent;
    }
    return 0.0;
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // Use parent simulation for smoother deceleration
    final Simulation? simulation =
    super.createBallisticSimulation(position, velocity);
    if (simulation != null) {
      return simulation;
    }
    return null;
  }
}