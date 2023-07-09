/// An abstractration of a state.
interface class State {
  /// Is an initial state.
  final bool isInitial;

  /// Is a state that can be treated as accept state of automaton.
  final bool isAccept;

  /// Name of the state.
  final String name;

  /// An optional label to sucintly describe the state.
  final String? label;

  const State({
    required this.name,
    required this.isAccept,
    required this.isInitial,
    this.label,
  });
}

/// A record type which stores the state, the char read and what state
/// the automaton should change.
///
/// Can be read as:
/// If the actual state of automaton is 'q0', and the character read is 'a',
/// assume the state 'q1'.
typedef TransitionFn = ({State actual, Symbol char, State nextState});

sealed class FormalDefinition {}

/// Formal definition of an automaton.
base class Quintuple implements FormalDefinition {
  final Set<State> states;
  final Set<Symbol> alphabet;
  final Set<TransitionFn> stateTable;
  final State start;
  final Set<State> acceptStates;

  const Quintuple({
    required this.states,
    required this.alphabet,
    required this.stateTable,
    required this.start,
    required this.acceptStates,
  });
}

extension Symbolify on String {
  /// Return the string in turned in a Symbol.
  Symbol get toSymbol => Symbol(this);
}

extension IterableString on String {
  Iterable<String> get iterable sync* {
    for (int i = 0; i < length; i++) {
      yield this[i];
    }
  }
}
