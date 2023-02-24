// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'maker_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MakerLoaded _$MakerLoadedFromJson(Map<String, dynamic> json) => MakerLoaded(
      qSelectedIndex: json['qSelectedIndex'] as int?,
      saveSuccess: json['saveSuccess'] as bool?,
      aSelectedIndex: json['aSelectedIndex'] as int?,
      quizTitle: json['quizTitle'] as String,
      datas: (json['datas'] as List<dynamic>)
          .map((e) => Question.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MakerLoadedToJson(MakerLoaded instance) =>
    <String, dynamic>{
      'saveSuccess': instance.saveSuccess,
      'quizTitle': instance.quizTitle,
      'qSelectedIndex': instance.qSelectedIndex,
      'aSelectedIndex': instance.aSelectedIndex,
      'datas': instance.datas,
    };

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      text: json['text'] as String?,
      textJson: json['textJson'] as String?,
      mp3: json['mp3'] as String?,
      img: (json['img'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'textJson': instance.textJson,
      'mp3': instance.mp3,
      'img': instance.img,
      'answers': instance.answers,
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      json['id'] as String,
      json['text'] as String?,
      json['img'] as String?,
      json['mp3'] as String?,
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'img': instance.img,
      'mp3': instance.mp3,
    };
