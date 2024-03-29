import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:json_annotation/json_annotation.dart';
import 'package:quizmaker/service/encrypt_service.dart';

part 'maker_state.g.dart';

enum QuestionInvalid { emptyQuestion, unselectedCorrect }

abstract class MakerState extends Equatable {
  const MakerState();

  @override
  List<Object?> get props => [];
}

class MakerInitial extends MakerState {
  @override
  List<Object?> get props => [];
}

class MakerError extends MakerState {
  final String msg;
  const MakerError({required this.msg});
  @override
  List<Object?> get props => [];
}

@JsonSerializable()
class MakerLoaded extends MakerState {
  final bool? saveSuccess;
  final String? makerUid;
  final String quizTitle;

  ///Selected question index
  final int qSelectedIndex;
  final int? aSelectedIndex;
  final List<Question> datas;

  const MakerLoaded(
      {required this.qSelectedIndex,
      this.saveSuccess,
      this.makerUid,
      this.aSelectedIndex,
      required this.quizTitle,
      required this.datas});
  factory MakerLoaded.fromJson(Map<String, dynamic> json) =>
      _$MakerLoadedFromJson(json);

  Map<String, dynamic> toJson() => _$MakerLoadedToJson(this);

  MakerLoaded copywith(
      {int? qSelectedIndex,
      int? aSelectedIndex,
      String? makerUid,
      List<Question>? datas,
      bool? saveSuccess}) {
    return MakerLoaded(
        quizTitle: quizTitle,
        saveSuccess: saveSuccess ?? this.saveSuccess,
        makerUid: makerUid ?? this.makerUid,
        datas: datas ?? this.datas,
        qSelectedIndex: qSelectedIndex ?? this.qSelectedIndex,
        aSelectedIndex: aSelectedIndex ?? this.aSelectedIndex);
  }

  QuestionInvalid? valdi() {
    for (var element in datas) {
      var correctSelected = element.answers.where(
        (element) {
          return EncryptService().getAnswerBool(element.id);
        },
      );
      if (correctSelected.isEmpty) {
        return QuestionInvalid.unselectedCorrect;
      }
      if (element.text!.trim().isEmpty) {
        return QuestionInvalid.emptyQuestion;
      }
    }
    return null;
  }

  MakerLoaded gotoQuestion(int qSelectedIndex) {
    return MakerLoaded(
      quizTitle: quizTitle,
      datas: datas,
      qSelectedIndex: qSelectedIndex,
    );
  }

  MakerLoaded deleteMsg() {
    return MakerLoaded(
        quizTitle: quizTitle,
        datas: datas,
        qSelectedIndex: qSelectedIndex,
        aSelectedIndex: aSelectedIndex);
  }

  @override
  List<Object?> get props =>
      [quizTitle, qSelectedIndex, aSelectedIndex, datas, saveSuccess];
}

@JsonSerializable()
class Question extends Equatable {
  final String id;
  final String? text;
  final String? textJson;
  final String? mp3;
  final List<String>? img;
  final List<Answer> answers;
  const Question(
      {required this.id,
      required this.answers,
      this.text,
      this.textJson,
      this.mp3,
      this.img});
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);

  Question copywith(
      {String? text, String? textJson, String? mp3, List<Answer>? answers}) {
    return Question(
        id: id,
        answers: answers ?? this.answers,
        text: text ?? this.text,
        textJson: textJson ?? this.textJson,
        mp3: mp3 ?? this.mp3,
        img: img);
  }

  QuestionInvalid? valdi() {
    var selectCorrect = answers
        .where((element) => (EncryptService().getAnswerBool(element.id)));
    if (selectCorrect.length != 1) {
      return QuestionInvalid.unselectedCorrect;
    }
    if (text!.trim().isEmpty) {
      return QuestionInvalid.emptyQuestion;
    }
    return null;
  }

  int valdiColor() {
    bool answerSelected = false;
    bool textNotEmpty = false;
    var getSelected = answers.where(
      (element) {
        return EncryptService().getAnswerBool(element.id);
      },
    );
    answerSelected = getSelected.isNotEmpty;
    textNotEmpty = text!.trim().isNotEmpty;
    if (answerSelected && textNotEmpty) {
      return 0xFF01cc01;
    } else if (!answerSelected && !textNotEmpty) {
      return 0xFF888888;
    } else if (!answerSelected || !textNotEmpty) {
      return 0xffd4c810;
    }
    return 0xFF888888;
  }

  @override
  String toString() {
    return 'id:$id,text:$text,textJ:$textJson,mp3:$mp3,img:$img,answers:$answers';
  }

  @override
  List<Object?> get props => [text, textJson, answers];
}

@JsonSerializable()
class Answer extends Equatable {
  final String id;
  final String? text;
  final String? img;
  final String? mp3;

  const Answer(this.id, this.text, this.img, this.mp3);
  factory Answer.fromJson(Map<String, dynamic> json) => _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);

  Answer copywith({String? id, String? text, String? img, String? mp3}) {
    return Answer(
        id ?? this.id, text ?? this.text, img ?? this.img, mp3 ?? this.img);
  }

  @override
  List<Object?> get props => [
        id,
        text,
      ];
  @override
  String toString() {
    return 'id:$id,text:$text,mp3:$mp3,img:$img,';
  }
}
