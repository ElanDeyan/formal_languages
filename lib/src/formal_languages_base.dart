import 'annotations/annotations.dart';

final class State {
  final bool isInitial;
  final bool isAccept;
  final String name;
  final String? label;

  const State(
      {required this.name,
      required this.isAccept,
      required this.isInitial,
      this.label});
}

@ToDo(what: 'Choose one of these two approaches')
// typedef TransitionFn = State Function(State actual, Symbol char);
typedef TransitionFn = ({State actual, Symbol char, State nextState});

typedef Quintuple = ({
  Set<State> states,
  Set<Symbol> alphabet,
  Set<TransitionFn> transitionFn,
  State initial,
  Set<State> acceptStates
});
