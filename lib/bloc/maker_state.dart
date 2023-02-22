part of 'maker_bloc.dart';

@immutable
abstract class MakerState extends Equatable {}

class MakerInitial extends MakerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MakerLoaded extends MakerState {
  final String quizTitle;
  final int? qSelectedIndex;
  final int? aSelectedIndex;
  final List<Question> datas;

  MakerLoaded(
      {this.qSelectedIndex,
      this.aSelectedIndex,
      required this.quizTitle,
      List<Question>? qDatas})
      : datas = qDatas ?? [];

  MakerLoaded copywith(
      {int? qSelectedIndex, int? aSelectedIndex, List<Question>? datas}) {
    return MakerLoaded(
        quizTitle: quizTitle,
        qDatas: datas ?? this.datas,
        qSelectedIndex: qSelectedIndex ?? this.qSelectedIndex,
        aSelectedIndex: aSelectedIndex ?? this.aSelectedIndex);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [quizTitle, qSelectedIndex, aSelectedIndex, datas];
}

class Question extends Equatable {
  final String id;
  final String? text;
  final String? textJson;
  final String? mp3;
  final List<String>? img;
  final List<Answer> answers;
  Question(this.id, List<Answer>? answers, this.text, this.textJson, this.mp3,
      this.img)
      : answers = answers ?? [];

  Question copywith(
    String? text,
    String? textJson,
    String? mp3,
  ) {
    return Question(
      id,
      answers,
      text ?? this.text,
      textJson ?? this.textJson,
      mp3 ?? this.mp3,
      img,
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return 'id:$id,text:$text,textJ:$textJson,mp3:$mp3,img:$img,answers:$answers';
  }

  @override
  // TODO: implement props
  List<Object?> get props => [text, textJson];
}

class Answer {
  final String id;
  final String? text;
  final String? img;
  final String? mp3;

  Answer(this.id, this.text, this.img, this.mp3);
  // "text": "isi text jawaban",
  //         "img": "id.png",
  //         "id": "hash(pertanyaanId+indexOnCreation+bool)"
}

// [id:42QKFDqShJH08s5GDvd2uQ==,text:null,mp3:null,img:null,answers:[], 
// id:42QKFDqShJH08s5HDvd2uQ==,text:null,mp3:null,img:null,answers:[]])