part of 'maker_bloc.dart';

@immutable
abstract class MakerEvent {}

class GoToNumber extends MakerEvent {
  final int number;
  GoToNumber(this.number);
}

class UpdateQuestion extends MakerEvent {
  final String stringPlain;
  final String stringJson;
  UpdateQuestion(this.stringPlain, this.stringJson);
}

class AddQuestion extends MakerEvent {
  // final int number;
  AddQuestion();
}

class Initialize extends MakerEvent {
  final String title;
  Initialize({required this.title});
}
