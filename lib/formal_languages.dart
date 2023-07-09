/// Support for doing something awesome.
///
/// More dartdocs go here.
library;

import 'dart:isolate';

import 'package:formal_languages/formal_languages.dart';

export 'src/formal_languages_base.dart';

sealed class FormalSystem {}

/// Deterministic finite automaton. A state machine capable to recognize words
/// from an alphabet.
base class DFA implements FormalSystem {
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

base class NFA implements FormalSystem {
  final Set<State> states;
  final Set<Symbol> alphabet;
  final Set<NFATransitionFn> stateTable;
  final State start;
  final Set<State> acceptStates;

  State _actual;
  State get actual => _actual;

  NFA({required NFAQuintuple quintuple})
      : states = quintuple.states,
        alphabet = quintuple.alphabet,
        stateTable = quintuple.stateTable,
        start = quintuple.start,
        acceptStates = quintuple.acceptStates,
        _actual = quintuple.start;

  Future<bool> recognize(String word) async {
    for (var i = 0; i < word.length; i++) {
      final char = word[i];
      try {
        final actualTransitionFn = _stateTransitionOf(_actual)
            .singleWhere((element) => element.char == char.toSymbol);
        switch (actualTransitionFn.nextStates.length) {
          case 0:
            return false;
          case 1:
            _actual = actualTransitionFn.nextStates.single;
          default:
            final List<(State, bool)> temp = [];
            final receivePort = ReceivePort();
            for (final state in actualTransitionFn.nextStates) {
              await Isolate.spawn(
                _isolateRecognization,
                (
                  substring: word.substring(i + 1),
                  newActual: state,
                  sendPort: receivePort.sendPort
                ),
              );
            }
            receivePort.listen((message) {
              if (message case (final State a, final bool b)) {
                temp.add((a, b));
              }
              if (temp.length == actualTransitionFn.nextStates.length) {
                receivePort.close();
              }
            });
            return temp.where((element) => element.$2 == true).isNotEmpty;
        }
      } on StateError catch (e) {
        print(e.message);
        return false;
      }
    }
    return _actual.isAccept;
  }

  Future<void> _isolateRecognization(
    ({String substring, State newActual, SendPort sendPort}) data,
  ) async {
    final (:substring, :newActual, :sendPort) = data;
    _actual = newActual;
    final result = await recognize(substring);
    sendPort.send((_actual, result));
  }

  Iterable<({Symbol char, Set<State> nextStates})> _stateTransitionOf(
    State state,
  ) sync* {
    for (final transitionFn in stateTable) {
      if (transitionFn.actual == state) {
        yield (char: transitionFn.char, nextStates: transitionFn.nextStates);
      }
    }
  }
}
