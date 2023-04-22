import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/file_service.dart';

part 'taker_event.dart';
part 'taker_state.dart';

class TakerBloc extends Bloc<TakerEvent, TakerState> {
  TakerBloc()
      : super(TakerState(
          selectedQuestionIndex: 0,
          maxQuestion: 0,
          path: '',
          quizdata: Question(id: 'initid', answers: [
            Answer(
                'answerinitid',
                jsonEncode([
                  {
                    'insert': '',
                  }
                ]),
                null,
                null)
          ]),
          selectedAnswer: const [],
        )) {
    on<TakerInitiate>((event, emit) async {
      var a = await FileService().takerJsonFile(p.basename(event.path));
      var b = jsonDecode(a);
      var c = MakerLoaded.fromJson(b);
      // print(c.datas.length);
      var thestate = TakerState(
        maxQuestion: c.datas.length,
        selectedQuestionIndex: 0,
        path: event.path,
        quizdata: c.datas[0],
        selectedAnswer: List.generate(
            c.datas.length,
            (index) => SelectedAnswer(
                  questionId: c.datas[index].id,
                )),
      );
      emit(thestate);
    });
    on<GotoQuestion>((event, emit) async {
      var a = await FileService().takerJsonFile(p.basename(state.path));
      var b = jsonDecode(a);
      var c = MakerLoaded.fromJson(b);
      var thestate = state.copywith(
        selectedQuestionIndex: event.index,
        quizdata: c.datas[event.index],
      );
      // print(thestate.quizdata?.text);
      emit(thestate);
    });

    on<SelectAnswer>((event, emit) async {
      List<SelectedAnswer> thelist = List.castFrom(state.selectedAnswer!);
      var newlist = thelist
          .map((element) => element.questionId == event.questionid
              ? element.copywith(selectedId: event.selectedid)
              : element)
          .toList();
      // print(newlist);
      emit(state.copywith(selectedAnswer: newlist));
    });
  }
}
