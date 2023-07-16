/// Non deterministic finite automaton implementation, with isolates!
library non_deterministic_finite_automaton;

import 'dart:isolate';
import 'package:formal_languages/non_deterministic_finite_automaton.dart';
export './src/formal_languages_base.dart' hide DFAQuintuple, DFATransitionFn;

base class NFA {
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

  Future<bool> accepts(String string, [State? actualState]) async {
    actualState ??= _actual;
    // First step, iterate over the string
    for (var i = 0; i < string.length; i++) {
      final char = string[i];
      if (!_hasTransition(actualState, char)) {
        return false;
      }
      final (actual: _, char: _, :nextStates) =
          _getTransitionsOf(actualState).singleWhere(
        (element) => element.char == char.toSymbol,
        orElse: () => (
          actual: const State(name: 'Empty', isAccept: false, isInitial: false),
          char: ''.toSymbol,
          nextStates: {},
        ),
      );
      switch (nextStates) {
        case final a when a.isEmpty:
          return false;
        case final a when a.length == 1:
          _actual = a.single;
          continue;
        default:
          final receivePorts = <ReceivePort>[];
          final isolates = <Isolate>[];
          final results = <bool>[];
          for (final state in nextStates) {
            final receivePort = ReceivePort();
            receivePorts.add(receivePort);

            final isolate = await Isolate.spawn(
              _recursiveAccepts,
              (
                sendPort: receivePort.sendPort,
                string: string.substring(i + 1),
                newState: state,
              ),
            );
            isolates.add(isolate);

            final result = await receivePort.first;
            results.add(result as bool);

            receivePort.close();
          }

          for (final isolate in isolates) {
            isolate.kill(priority: Isolate.immediate);
          }

          if (results.any((element) => true)) {
            return true;
          } else {
            return false;
          }
      }
    }
    return _actual.isAccept;
  }
  
  Future<void> _recursiveAccepts(
    ({SendPort sendPort, String string, State newState}) data,
  ) async {
    var (:sendPort, :string, :newState) = data;
    for (int i = 0; i < string.length; i++) {
      final char = string[i];
      if (!_hasTransition(newState, char)) {
        sendPort.send(false);
      }
      final (actual: _, char: _, :nextStates) =
          _getTransitionsOf(newState).singleWhere(
        (element) => element.char == char.toSymbol,
        orElse: () => (
          actual: const State(name: 'Empty', isAccept: false, isInitial: false),
          char: ''.toSymbol,
          nextStates: <State>{}
        ),
      );
      switch (nextStates) {
        case final a when a.isEmpty:
          sendPort.send(false);
        case final a when a.length == 1:
          newState = a.single;
          continue;
        default:
          final receivePorts = <ReceivePort>[];
          final isolates = <Isolate>[];
          final results = [];
          for (final state in nextStates) {
            final receivePort = ReceivePort();
            receivePorts.add(receivePort);

            final isolate = await Isolate.spawn(
              _recursiveAccepts,
              (
                sendPort: receivePort.sendPort,
                string: string.substring(i + 1),
                newState: state,
              ),
            );
            isolates.add(isolate);

            final result = await receivePort.first;
            results.add(result);

            receivePort.close();
          }

          for (final isolate in isolates) {
            isolate.kill(priority: Isolate.immediate);
          }

          if (results.any((element) => true)) {
            sendPort.send(true);
          } else {
            sendPort.send(false);
          }
      }
    }
    sendPort.send(newState.isAccept);
  }

  Iterable<NFATransitionFn> _getTransitionsOf(State actual) sync* {
    for (final transitionFn in stateTable) {
      if (transitionFn.actual == actual) {
        yield (
          actual: actual,
          char: transitionFn.char,
          nextStates: transitionFn.nextStates
        );
      }
    }
  }

  bool _hasTransition(State state, String char) {
    if (_getTransitionsOf(state)
        .any((element) => element.char == char.toSymbol)) {
      return true;
    }
    return false;
  }
}
