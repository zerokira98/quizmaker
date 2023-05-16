part of 'navrail_cubit.dart';

class NavrailState extends Equatable {
  final RailViewMode viewmode;
  final bool expanded;
  final List<String> titles;
  final List<int> answerSelected;
  final int selectedIndex;
  const NavrailState(
      {required this.titles,
      required this.answerSelected,
      required this.expanded,
      required this.selectedIndex,
      required this.viewmode});

  NavrailState copywith({
    RailViewMode? viewmode,
    bool? expanded,
    List<int>? answerSelected,
    List<String>? titles,
    int? selectedIndex,
  }) {
    return NavrailState(
        answerSelected: answerSelected ?? this.answerSelected,
        viewmode: viewmode ?? this.viewmode,
        expanded: expanded ?? this.expanded,
        titles: titles ?? this.titles,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props =>
      [titles, selectedIndex, viewmode, expanded, answerSelected];
}
