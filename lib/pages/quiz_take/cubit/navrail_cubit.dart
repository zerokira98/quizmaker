import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:quizmaker/bloc/maker/maker_state.dart';
import 'package:quizmaker/service/file_service.dart';
import 'package:path/path.dart' as p;

part 'navrail_state.dart';

class NavrailCubit extends Cubit<NavrailState> {
  NavrailCubit() : super(const NavrailState(selectedIndex: 0, titles: []));

  init({required String path}) async {
    var a = await FileService().takerJsonFile(p.basename(path));
    var b = jsonDecode(a);
    var c = MakerLoaded.fromJson(b);
    var d = List.generate(c.datas.length, (index) => c.datas[index].text!);
    emit(NavrailState(selectedIndex: 0, titles: d));
  }

  selectindex(int index) {
    emit(state.copywith(selectedIndex: index));
  }
}
