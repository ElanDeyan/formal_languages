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

  const State(
      {required this.name,
      required this.isAccept,
      required this.isInitial,
      this.label});
}

/// A record type which stores the state, the char read and what state
/// the automaton should change.
/// 
/// Can be read as:
/// If the actual state of automaton is 'q0', and the character read is 'a',
/// assume the state 'q1'.
typedef TransitionFn = ({State actual, Symbol char, State nextState});

/// Formal definition of an automaton.
typedef Quintuple = ({
  Set<State> states,
  Set<Symbol> alphabet,
  Set<TransitionFn> stateTable,
  State initial,
  Set<State> acceptStates
});
