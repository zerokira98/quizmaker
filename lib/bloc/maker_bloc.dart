import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:quizmaker/service/encrypt_service.dart';
import 'package:quizmaker/service/file_service.dart';
import 'maker_state.dart';

part 'maker_event.dart';

class MakerBloc extends Bloc<MakerEvent, MakerState> {
  MakerBloc() : super(MakerInitial()) {
    on<ReturntoInitial>(_backtoInitialstate);
    on<Initialize>(_initialize);
    on<InitiateFromFolder>(_initializeFromFolder);
    on<GoToNumber>(_goToNumber);
    on<SavetoFile>(_savetoFile);
    on<DeleteSuccess>(_deleteSuccess);
    on<AddQuestion>(_addQuestion);
    on<DeleteQuestion>(_deleteQuestion);
    on<UpdateQuestion>(_updateQuestion);

    ///--Answer
    on<AddAnswer>(_addAnswer);
  }
  _initializeFromFolder(
      InitiateFromFolder event, Emitter<MakerState> emit) async {
    var jsonFile = jsonDecode(await FileService().quizJsonFile(event.folder));
    emit(MakerLoaded.fromJson(jsonFile));
  }

  _savetoFile(SavetoFile event, Emitter<MakerState> emit) async {
    var bool = await FileService().saveToFile(state as MakerLoaded);
    emit((state as MakerLoaded).copywith(
      saveSuccess: bool,
    ));
  }

  _deleteSuccess(DeleteSuccess event, Emitter<MakerState> emit) async {
    emit((state as MakerLoaded).deleteMsg());
  }

  _backtoInitialstate(ReturntoInitial event, Emitter<MakerState> emit) async {
    emit(MakerInitial());
  }

  _deleteQuestion(DeleteQuestion event, Emitter<MakerState> emit) async {
    var a = (state as MakerLoaded).datas.toList();
    if (a.length > 1) {
      a.removeAt(event.index);
      var newQselectindex = (state as MakerLoaded).qSelectedIndex! > 0
          ? (state as MakerLoaded).qSelectedIndex! - 1
          : 0;
      emit((state as MakerLoaded)
          .copywith(datas: a, qSelectedIndex: newQselectindex));
    } else {
      add(Initialize(title: (state as MakerLoaded).quizTitle));
    }
  }

  _initialize(Initialize event, Emitter<MakerState> emit) async {
    var projectDir = await FileService().createNewProjectDir(event.title);
    final title = '${event.title}_0';
    var qId = await EncryptService().questionIdfromIndex(title);
    var questData = Question(id: qId, answers: []);
    var newState = MakerLoaded(
        quizTitle: event.title, datas: [questData], qSelectedIndex: 0);
    var file = File('${projectDir.path}quiz.json');
    await file.writeAsString(jsonEncode(newState.toJson()));
    emit(newState);
  }

  _goToNumber(GoToNumber event, Emitter<MakerState> emit) async {
    if (state is MakerLoaded) {
      emit((state as MakerLoaded).copywith(qSelectedIndex: event.number));
    }
  }

  _updateQuestion(UpdateQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var updatedQuestion = theState.datas[theState.qSelectedIndex!]
        .copywith(text: event.stringPlain, textJson: event.stringJson);
    var selectedId = theState.datas[theState.qSelectedIndex!].id;
    var newdatas = theState.datas
        .map((e) => e.id == selectedId ? updatedQuestion : e)
        .toList();
    emit(theState.copywith(datas: newdatas));
  }

  _addAnswer(AddAnswer event, Emitter<MakerState> emit) async {
    var currState = (state as MakerLoaded);
    var datas = currState.datas;
    var id = await EncryptService()
        .setAnswerId(0, datas[currState.qSelectedIndex!].id, false);
    var newAnswer = Answer(id, '', null, null);
    List<Question> telo = datas
        .map((e) => e.id == datas[currState.qSelectedIndex!].id
            ? e.copywith(answers: e.answers + [newAnswer])
            : e)
        .toList();
    // datas[currState.qSelectedIndex!].answers.add(newAnswer);
    debugPrint('$datas');
    emit(currState.copywith(
      datas: telo,
      // aSelectedIndex:
      //     currState.aSelectedIndex != null ? currState.aSelectedIndex! + 1 : 0,
    ));
  }

  _addQuestion(AddQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var prevdata = (state as MakerLoaded).datas;
    var indexfromId =
        await EncryptService().getQuestionIndexfromId(prevdata.last.id);
    var id = '${theState.quizTitle}_${indexfromId + 1}';
    final encrypted = await EncryptService().questionIdfromIndex(id);
    var newQuestion = Question(id: encrypted, answers: []);
    var newDatas = prevdata + [newQuestion];
    // var newState = MakerLoaded(
    //     quizTitle: theState.quizTitle,
    //     qSelectedIndex: prevdata.length,
    //     datas: newDatas);
    emit(theState.copywith(datas: newDatas));
  }
}
