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

class SetRightAnswer extends MakerEvent {
  final int index;
  SetRightAnswer({required this.index});
}

class DeleteAnswer extends MakerEvent {
  final int index;
  DeleteAnswer({required this.index});
}

class SelectAnswer extends MakerEvent {
  final int index;
  SelectAnswer(this.index);
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

class InitiateFromZip extends MakerEvent {
  final String zippath;
  final String title;
  InitiateFromZip({required this.zippath, required this.title});
}
