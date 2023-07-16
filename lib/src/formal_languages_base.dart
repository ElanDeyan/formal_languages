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
typedef DFATransitionFn = ({State actual, Symbol char, State nextState});

/// A record type which stores the state, the char read and the set of states
/// which the automaton should change.
///
/// Can be read as:
/// If the actual state of automaton is 'q0', and the character read is 'a',
/// assume the states 'q1,q2'.
typedef NFATransitionFn = ({State actual, Symbol char, Set<State> nextStates});

sealed class FormalDefinition {}

/// Formal definition of an automaton.
base class DFAQuintuple implements FormalDefinition {
  /// Set of [states] of the automaton.
  final Set<State> states;

  /// The [alphabet] of Symbols accepted by the automaton.
  final Set<Symbol> alphabet;

  /// Set of transitions, looks like a [stateTable], with the transitions of the [states].
  final Set<DFATransitionFn> stateTable;

  /// The [start] state of the automaton.
  final State start;

  /// Set of [acceptStates] where the automaton can accept the string.
  final Set<State> acceptStates;

  /// 5-tuple with the elements of the automaton:
  /// 1. Set of [states]
  /// 2. Language [alphabet] accepted by the automaton.
  /// 3. Set of transition, looks like a [stateTable], defining the transitions of [states].
  /// 4. The [start] state of the automaton.
  /// 5. Set of [acceptStates] of the automaton.
  const DFAQuintuple({
    required this.states,
    required this.alphabet,
    required this.stateTable,
    required this.start,
    required this.acceptStates,
  });
}

/// Formal definition of the Non-deterministic automaton.
final class NFAQuintuple implements FormalDefinition {
  /// Set of [states] of the automaton.
  final Set<State> states;

  /// The [alphabet] of Symbols accepted by the automaton.
  final Set<Symbol> alphabet;

  /// Set of transitions, looks like a [stateTable],
  /// with the transitions of the [states].
  /// Follows the [DFATransitionFn] definition.
  final Set<NFATransitionFn> stateTable;

  /// The [start] state of the automaton.
  final State start;

  /// Set of [acceptStates] where the automaton can accept the string.
  final Set<State> acceptStates;

  /// 5-tuple with the elements of the automaton:
  /// 1. Set of [states]
  /// 2. Language [alphabet] accepted by the automaton.
  /// 3. Set of transition, looks like a [stateTable], defining the transitions of [states], follows the [NFATransitionFn] definition.
  /// 4. The [start] state of the automaton.
  /// 5. Set of [acceptStates] of the automaton.
  const NFAQuintuple({
    required this.states,
    required this.alphabet,
    required this.stateTable,
    required this.start,
    required this.acceptStates,
  });
}

extension Symbolify on String {
  /// Return the string turned in a Symbol.
  Symbol get toSymbol => Symbol(this);
}

extension IterableString on String {
  /// Gets a lazy evaluated [Iterable] of any [String].
  Iterable<String> get iterable sync* {
    for (int i = 0; i < length; i++) {
      yield this[i];
    }
  }
}

sealed class FormalSystem {}
