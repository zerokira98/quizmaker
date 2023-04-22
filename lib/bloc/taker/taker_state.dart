part of 'taker_bloc.dart';

class TakerState extends Equatable {
  final String path;
  final int selectedQuestionIndex;
  final int maxQuestion;
  final Question? quizdata;
  final List<SelectedAnswer>? selectedAnswer;
  const TakerState(
      {required this.selectedQuestionIndex,
      required this.maxQuestion,
      required this.path,
      this.selectedAnswer,
      this.quizdata});

  TakerState copywith(
      {int? selectedQuestionIndex,
      List<SelectedAnswer>? selectedAnswer,
      Question? quizdata,
      int? maxQuestion,
      String? path}) {
    return TakerState(
        maxQuestion: maxQuestion ?? this.maxQuestion,
        selectedQuestionIndex:
            selectedQuestionIndex ?? this.selectedQuestionIndex,
        selectedAnswer: selectedAnswer ?? this.selectedAnswer,
        quizdata: quizdata ?? this.quizdata,
        path: path ?? this.path);
  }

  @override
  List<Object> get props =>
      [selectedQuestionIndex, maxQuestion, path, quizdata!, selectedAnswer!];
}

class TakerStateInitial extends Equatable {
  const TakerStateInitial();

  @override
  List<Object> get props => [];
}

class SelectedAnswer extends Equatable {
  final String? selectedId;
  final String questionId;

  const SelectedAnswer({this.selectedId, required this.questionId});

  SelectedAnswer copywith({String? selectedId, String? questionId}) {
    return SelectedAnswer(
        questionId: questionId ?? this.questionId,
        selectedId: selectedId ?? this.selectedId);
  }

  @override
  String toString() {
    return "questionId:$questionId, selectedid:$selectedId";
  }

  @override
  List<Object?> get props => [selectedId, questionId];
}
