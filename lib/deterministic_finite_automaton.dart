/// Deterministic finite automaton implementation.
library deterministic_finite_automaton;

import 'package:formal_languages/deterministic_finite_automaton.dart';
export 'src/formal_languages_base.dart' hide NFAQuintuple, NFATransitionFn;

/// Deterministic finite automaton. A state machine capable to recognize words
/// from an alphabet.
base class DFA {
  final Set<State> states;
  final Set<Symbol> alphabet;
  final Set<DFATransitionFn> stateTable;
  final State start;
  final Set<State> acceptStates;
  State _actual;

  State get actual => _actual;

  DFA({required DFAQuintuple quintuple})
      : states = quintuple.states,
        alphabet = quintuple.alphabet,
        stateTable = quintuple.stateTable,
        start = quintuple.start,
        acceptStates = quintuple.acceptStates,
        _actual = quintuple.start;

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
