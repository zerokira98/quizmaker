import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/file_service.dart';
import 'package:path/path.dart' as p;

part 'navrail_state.dart';

enum RailViewMode { list, grid }

class NavrailCubit extends Cubit<NavrailState> {
  NavrailCubit()
      : super(const NavrailState(
            selectedIndex: 0,
            answerSelected: [],
            titles: [],
            viewmode: RailViewMode.list,
            expanded: true));

  init({required String path}) async {
    var a = await FileService().takerJsonFile(p.basename(path));
    var b = jsonDecode(a);
    var c = MakerLoaded.fromJson(b);
    var d = List.generate(c.datas.length, (index) => c.datas[index].text!);
    emit(NavrailState(
        answerSelected: const [],
        selectedIndex: 0,
        titles: d,
        viewmode: RailViewMode.list,
        expanded: true));
  }

  selectindex(int index) {
    emit(state.copywith(selectedIndex: index));
  }

  changeviewmode() {
    emit(state.copywith(
        viewmode: RailViewMode.values[(state.viewmode.index + 1) % 2]));
  }

  expand() {
    emit(state.copywith(expanded: !state.expanded));
  }

  setAnswered(int index) {
    List<int> newlist = List.from(state.answerSelected);
    if (!state.answerSelected.contains(index)) newlist.add(index);
    emit(state.copywith(answerSelected: newlist));
  }
}
