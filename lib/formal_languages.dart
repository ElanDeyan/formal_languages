/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'package:formal_languages/formal_languages.dart';
import 'package:formal_languages/src/annotations/annotations.dart';

export 'src/formal_languages_base.dart';

sealed class FormalSystem {}

/// Deterministic finite automaton. A state machine capable to recognize words
/// from an alphabet.
base class DFA implements FormalSystem {
  final Set<State> states;
  final Set<Symbol> alphabet;
  final Set<TransitionFn> stateTable;
  final State start;
  final Set<State> acceptStates;
  State _actual;

  State get actual => _actual;

  DFA({required Quintuple quintuple})
      : states = quintuple.states,
        alphabet = quintuple.alphabet,
        stateTable = quintuple.stateTable,
        start = quintuple.start,
        acceptStates = quintuple.acceptStates,
        _actual = quintuple.start;

  @ToDo(what: 'Implement the recognize method.')
  bool recognize(String word) {
    for (final char in word.iterable) {
      final actualTransitionFn = _stateTransitionOf(_actual);
      try {
        final transition = actualTransitionFn.singleWhere(
          (element) => element.char == char.toSymbol,
        );
        _actual = transition.next;
      } on StateError {
        return false;
      }
    }
    return _actual.isAccept;
  }

  Iterable<({Symbol char, State next})> _stateTransitionOf(
    State state,
  ) sync* {
    for (final transitionFn in stateTable) {
      if (transitionFn.actual == state) {
        yield (char: transitionFn.char, next: transitionFn.nextState);
      }
    }
  }
}
