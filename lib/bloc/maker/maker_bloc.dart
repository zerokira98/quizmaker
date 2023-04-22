///====BLOC HELLS====
///
///

import 'dart:convert';

import 'package:archive/archive_io.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:quizmaker/repo/authrepo/authrepo.dart';
import 'package:quizmaker/service/encrypt_service.dart';
import 'package:quizmaker/service/file_service.dart';
import 'maker_state.dart';

part 'maker_event.dart';

class MakerBloc extends Bloc<MakerEvent, MakerState> {
  AuthenticationRepository repo;
  MakerBloc({required this.repo}) : super(MakerInitial()) {
    on<ReturntoInitial>(_backtoInitialstate);
    on<Initialize>(_initialize);
    on<InitiateFromFolder>(_initializeFromFolder);
    on<InitiateFromZip>(_initializeFromZip);
    on<GoToNumber>(_goToNumber);
    on<SavetoFile>(_savetoFile);
    on<DeleteSuccess>(_deleteSuccess);
    on<AddQuestion>(_addQuestion);
    on<DeleteQuestion>(_deleteQuestion);
    on<UpdateQuestion>(_updateQuestion);

    ///--Answer
    on<AddAnswer>(_addAnswer);
    on<SelectAnswer>(_selectAnswer);
    on<SetRightAnswer>(_setRightAnswer);
    on<DeleteAnswer>(_deleteAnswer);
  }
  _initializeFromZip(InitiateFromZip event, Emitter<MakerState> emit) async {
    var projectDir =
        join(await FileService().getQuizMakerProjectDir(), event.title);
    await extractFileToDisk(event.zippath, projectDir);
    // print('IM HERE');
    add(InitiateFromFolder(folder: projectDir));
  }

  _initializeFromFolder(
      InitiateFromFolder event, Emitter<MakerState> emit) async {
    if (state is MakerInitial) {
      try {
        var jsonFile =
            jsonDecode(await FileService().quizJsonFile(event.folder));
        var decodedState = MakerLoaded.fromJson(jsonFile);
        var newState = decodedState.gotoQuestion(0);
        emit(newState);
      } catch (e) {
        emit(MakerError(msg: e.toString()));
      }
    }
  }

  _savetoFile(SavetoFile event, Emitter<MakerState> emit) async {
    try {
      var bool = await FileService().saveToFile(state as MakerLoaded);
      emit((state as MakerLoaded).copywith(
        saveSuccess: bool,
      ));
      Future.delayed(const Duration(seconds: 5)).whenComplete(() {
        add(DeleteSuccess());
      });
    } catch (e) {
      emit((state as MakerLoaded).copywith(
        saveSuccess: false,
      ));
    }
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
      var newQselectindex = (state as MakerLoaded).qSelectedIndex > 0
          ? (state as MakerLoaded).qSelectedIndex - 1
          : 0;
      emit((state as MakerLoaded)
          .copywith(datas: a, qSelectedIndex: newQselectindex));
    } else {
      add(Initialize(title: (state as MakerLoaded).quizTitle));
    }
  }

  _initialize(Initialize event, Emitter<MakerState> emit) async {
    try {
      var projectDir = await FileService().createNewProjectDir(event.title);
      final title = '${event.title}_0';
      var qId = await EncryptService().questionIdfromIndex(title);
      var questData = Question(id: qId, answers: const []);

      ///
      for (var i = 0; i < 4; i++) {
        var aId = EncryptService().setAnswerId(i, qId, false);
        var newAnswer = Answer(aId, '', null, null);
        questData =
            questData.copywith(answers: questData.answers + [newAnswer]);
      }
      var newState = MakerLoaded(
          quizTitle: event.title,
          datas: [questData],
          qSelectedIndex: 0,
          makerUid: repo.currentUser.id);
      var isSuccess = await FileService().saveToFile(newState);
      if (!isSuccess) throw Exception('not true');
      // var file = File('${projectDir.path}quiz.json');
      // await file.writeAsString(jsonEncode(newState.toJson()));
      emit(newState);
      // add(AddAnswer());
      add(GoToNumber(0));
    } catch (e) {
      throw Exception('error:$e');
    }
  }

  _setRightAnswer(SetRightAnswer event, Emitter<MakerState> emit) async {
    var idx = event.index;
    var theState = (state as MakerLoaded);
    var prevanswers = theState.datas[theState.qSelectedIndex].answers;
    var answers = prevanswers.map((e) {
      var index = EncryptService().getAnswerIndex(e.id);
      var tofalse = EncryptService().setAnswerId(
          index, theState.datas[theState.qSelectedIndex].id, false);
      return e.copywith(id: tofalse);
    }).toList();
    var selected = answers[idx];
    var index = EncryptService().getAnswerIndex(selected.id);
    var totrue = EncryptService()
        .setAnswerId(index, theState.datas[theState.qSelectedIndex].id, true);
    var finalanswers = answers
        .map((e) => e.id == selected.id ? e.copywith(id: totrue) : e)
        .toList();
    emit(theState.copywith(
        datas: theState.datas
            .map((e) => e.id == theState.datas[theState.qSelectedIndex].id
                ? e.copywith(answers: finalanswers)
                : e)
            .toList()));
  }

  _selectAnswer(SelectAnswer event, Emitter<MakerState> emit) async {
    if (state is MakerLoaded) {
      emit((state as MakerLoaded).copywith(aSelectedIndex: event.index));
    }
  }

  _deleteAnswer(DeleteAnswer event, Emitter<MakerState> emit) async {
    if (state is MakerLoaded) {
      var thestate = (state as MakerLoaded);
      var datas = thestate.datas;
      List<Answer> a = thestate.datas[thestate.qSelectedIndex].answers.toList();
      a.removeAt(event.index);
      List<Question> telo = datas
          .map((e) => e.id == datas[thestate.qSelectedIndex].id
              ? e.copywith(answers: a)
              : e)
          .toList();

      emit((state as MakerLoaded).copywith(datas: telo));
      if (a.isEmpty) {
        add(GoToNumber(thestate.qSelectedIndex));
      }
    }
  }

  _goToNumber(GoToNumber event, Emitter<MakerState> emit) async {
    if (state is MakerLoaded) {
      emit((state as MakerLoaded).gotoQuestion(event.number));
    }
  }

  _updateQuestion(UpdateQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var selectedId = theState.datas[theState.qSelectedIndex].id;
    if (theState.aSelectedIndex == null) {
      var updatedQuestion = theState.datas[theState.qSelectedIndex]
          .copywith(text: event.stringPlain, textJson: event.stringJson);
      var newdatas = theState.datas
          .map((e) => e.id == selectedId ? updatedQuestion : e)
          .toList();
      emit(theState.copywith(datas: newdatas));
    } else {
      var selectedAnswerId = theState
          .datas[theState.qSelectedIndex].answers[theState.aSelectedIndex!].id;
      List<Answer> newAnswers = theState.datas[theState.qSelectedIndex].answers
          .map((e) =>
              e.id == selectedAnswerId ? e.copywith(text: event.stringJson) : e)
          .toList();
      var updatedQuestion =
          theState.datas[theState.qSelectedIndex].copywith(answers: newAnswers);
      var newdatas = theState.datas
          .map((e) => e.id == selectedId ? updatedQuestion : e)
          .toList();
      emit(theState.copywith(datas: newdatas));
    }
  }

  _addAnswer(AddAnswer event, Emitter<MakerState> emit) async {
    var currState = (state as MakerLoaded);
    var datas = currState.datas;
    var index = 0;
    if (datas[currState.qSelectedIndex].answers.isNotEmpty) {
      index = EncryptService()
              .getAnswerIndex(datas[currState.qSelectedIndex].answers.last.id) +
          1;
    }
    var id = EncryptService()
        .setAnswerId(index, datas[currState.qSelectedIndex].id, false);
    var newAnswer = Answer(id, '', null, null);
    List<Question> telo = datas
        .map((e) => e.id == datas[currState.qSelectedIndex].id
            ? e.copywith(answers: e.answers + [newAnswer])
            : e)
        .toList();
    // datas[currState.qSelectedIndex!].answers.add(newAnswer);
    // debugPrint('${currState.aSelectedIndex}');
    emit(currState.copywith(
      datas: telo,
      aSelectedIndex: index,
    ));
  }

  _addQuestion(AddQuestion event, Emitter<MakerState> emit) async {
    var theState = (state as MakerLoaded);
    var prevdata = (state as MakerLoaded).datas;
    var indexfromId =
        await EncryptService().getQuestionIndexfromId(prevdata.last.id);
    var id = '${theState.quizTitle}_${indexfromId + 1}';
    final encrypted = await EncryptService().questionIdfromIndex(id);
    var newQuestion = Question(id: encrypted, answers: const []);
    var newDatas = prevdata + [newQuestion];
    emit(theState.copywith(datas: newDatas));
    add(GoToNumber(theState.datas.length));
    for (var i = 0; i < 4; i++) {
      add(AddAnswer());
    }
    add(GoToNumber(theState.datas.length));
  }
}
