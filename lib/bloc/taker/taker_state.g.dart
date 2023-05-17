// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taker_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TakerState _$TakerStateFromJson(Map<String, dynamic> json) => TakerState(
      selectedQuestionIndex: json['selectedQuestionIndex'] as int,
      maxQuestion: json['maxQuestion'] as int,
      path: json['path'] as String,
      selectedAnswer: (json['selectedAnswer'] as List<dynamic>?)
          ?.map((e) => SelectedAnswer.fromJson(e as Map<String, dynamic>))
          .toList(),
      quizdata: json['quizdata'] == null
          ? null
          : Question.fromJson(json['quizdata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TakerStateToJson(TakerState instance) =>
    <String, dynamic>{
      'path': instance.path,
      'selectedQuestionIndex': instance.selectedQuestionIndex,
      'maxQuestion': instance.maxQuestion,
      'quizdata': instance.quizdata,
      'selectedAnswer': instance.selectedAnswer,
    };

SelectedAnswer _$SelectedAnswerFromJson(Map<String, dynamic> json) =>
    SelectedAnswer(
      selectedId: json['selectedId'] as String?,
      questionId: json['questionId'] as String,
    );

Map<String, dynamic> _$SelectedAnswerToJson(SelectedAnswer instance) =>
    <String, dynamic>{
      'selectedId': instance.selectedId,
      'questionId': instance.questionId,
    };
