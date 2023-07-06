/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:formal_languages/formal_languages.dart';

export 'src/formal_languages_base.dart';

// TODO: Export any libraries intended for clients of this package.

void main(List<String> args) {
  Set<State> myStates = {
    State(name: 'q0', isAccept: false, isInitial: true),
    for (int i = 1; i < 3; i++)
      State(name: 'q$i', isAccept: false, isInitial: false),
    State(name: 'q3', isAccept: true, isInitial: false)
  };
  Set<TransitionFn> transitionTable = {
    (actual: myStates.first, char: Symbol('a'), nextState: myStates.last )
  };
}
