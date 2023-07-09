import 'package:formal_languages/formal_languages.dart';

void main() async {
  // // An example of an automaton which recognize whether a binary number has
  // // even numbers of zero.
  // final states = <String, State>{
  //   'S1': const State(name: 'S1', isAccept: true, isInitial: true),
  //   'S2': const State(name: 'S2', isAccept: false, isInitial: false),
  // };

  // final DFA myFirstAutomaton = DFA(
  //   quintuple: DFAQuintuple(
  //     states: {...states.values},
  //     alphabet: {
  //       for (final char in {0, 1}) '$char'.toSymbol
  //     },
  //     stateTable: <DFATransitionFn>{
  //       (actual: states['S1']!, char: '0'.toSymbol, nextState: states['S2']!),
  //       (actual: states['S1']!, char: '1'.toSymbol, nextState: states['S1']!),
  //       (actual: states['S2']!, char: '0'.toSymbol, nextState: states['S1']!),
  //       (actual: states['S2']!, char: '1'.toSymbol, nextState: states['S2']!),
  //     },
  //     start: states['S1']!,
  //     acceptStates: {states['S1']!},
  //   ),
  // );

  // print(myFirstAutomaton.recognize('0010101')); // prints true

  final nfaStates = <String, State>{
    'p': const State(name: 'p', isAccept: false, isInitial: true),
    'q': const State(name: 'q', isAccept: true, isInitial: false)
  };

  final NFA myFirstNFA = NFA(
    quintuple: NFAQuintuple(
      states: {...nfaStates.values},
      alphabet: {
        for (final char in {0, 1}) '$char'.toSymbol
      },
      stateTable: <NFATransitionFn>{
        (
          actual: nfaStates['p']!,
          char: '0'.toSymbol,
          nextStates: {nfaStates['p']!}
        ),
        (
          actual: nfaStates['p']!,
          char: '1'.toSymbol,
          nextStates: {...nfaStates.values}
        ),
        (
          actual: nfaStates['q']!,
          char: '0'.toSymbol,
          nextStates: {},
        ),
        (
          actual: nfaStates['q']!,
          char: '1'.toSymbol,
          nextStates: {},
        )
      },
      start: nfaStates['p']!,
      acceptStates: {nfaStates['q']!},
    ),
  );

  print(await myFirstNFA.recognize('01'));
}
