part of 'navrail_cubit.dart';

class NavrailState extends Equatable {
  final List<String> titles;
  final int selectedIndex;
  const NavrailState({required this.titles, required this.selectedIndex});

  NavrailState copywith({
    List<String>? titles,
    int? selectedIndex,
  }) {
    return NavrailState(
        titles: titles ?? this.titles,
        selectedIndex: selectedIndex ?? this.selectedIndex);
  }

  @override
  List<Object> get props => [titles, selectedIndex];
}
