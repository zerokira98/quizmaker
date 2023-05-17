part of 'taker_bloc.dart';

abstract class TakerEvent extends Equatable {
  const TakerEvent();

  @override
  List<Object> get props => [];
}

class TakerInitiate extends TakerEvent {
  final String path;
  const TakerInitiate({required this.path});
}

class GotoQuestion extends TakerEvent {
  final int index;
  const GotoQuestion({required this.index});
}

class SelectAnswer extends TakerEvent {
  final String questionid;
  final String selectedid;
  const SelectAnswer({required this.questionid, required this.selectedid});
}
