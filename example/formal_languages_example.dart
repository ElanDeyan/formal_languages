import 'package:formal_languages/formal_languages.dart';

void main() {
  // An example of an automaton which recognize whether a binary number has
  // even numbers of zero.
  final states = <String, State>{
    'S1': const State(name: 'S1', isAccept: true, isInitial: true),
    'S2': const State(name: 'S2', isAccept: false, isInitial: false),
  };

  final DFA myFirstAutomaton = DFA(
    quintuple: Quintuple(
      states: {...states.values},
      alphabet: {
        for (final char in {0, 1}) '$char'.toSymbol
      },
      stateTable: <TransitionFn>{
        (actual: states['S1']!, char: '0'.toSymbol, nextState: states['S2']!),
        (actual: states['S1']!, char: '1'.toSymbol, nextState: states['S1']!),
        (actual: states['S2']!, char: '0'.toSymbol, nextState: states['S1']!),
        (actual: states['S2']!, char: '1'.toSymbol, nextState: states['S2']!),
      },
      start: states['S1']!,
      acceptStates: {states['S1']!},
    ),
  );

  print(myFirstAutomaton.recognize('0010101')); // prints true
}
