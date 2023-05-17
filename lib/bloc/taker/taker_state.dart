import 'package:equatable/equatable.dart';

// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';

part 'taker_state.g.dart';

// part of 'taker_bloc.dart';
@JsonSerializable()
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

  factory TakerState.fromJson(Map<String, dynamic> json) =>
      _$TakerStateFromJson(json);

  Map<String, dynamic> toJson() => _$TakerStateToJson(this);

  @override
  List<Object> get props =>
      [selectedQuestionIndex, maxQuestion, path, quizdata!, selectedAnswer!];
}

class TakerStateInitial extends Equatable {
  const TakerStateInitial();

  @override
  List<Object> get props => [];
}

@JsonSerializable()
class SelectedAnswer extends Equatable {
  final String? selectedId;
  final String questionId;

  const SelectedAnswer({this.selectedId, required this.questionId});

  SelectedAnswer copywith({String? selectedId, String? questionId}) {
    return SelectedAnswer(
        questionId: questionId ?? this.questionId,
        selectedId: selectedId ?? this.selectedId);
  }

  factory SelectedAnswer.fromJson(Map<String, dynamic> json) =>
      _$SelectedAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$SelectedAnswerToJson(this);

  @override
  String toString() {
    return "questionId:$questionId, selectedid:$selectedId";
  }

  @override
  List<Object?> get props => [selectedId, questionId];
}
