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
  AddQuestion();
}

class AddAnswer extends MakerEvent {
  AddAnswer();
}

class SavetoFile extends MakerEvent {
  SavetoFile();
}

class DeleteSuccess extends MakerEvent {
  DeleteSuccess();
}

class DeleteQuestion extends MakerEvent {
  final int index;
  DeleteQuestion(this.index);
}

class ReturntoInitial extends MakerEvent {
  // final int index;
  ReturntoInitial();
}

class Initialize extends MakerEvent {
  final String title;
  Initialize({required this.title});
}

class InitiateFromFolder extends MakerEvent {
  final String folder;
  InitiateFromFolder({required this.folder});
}
