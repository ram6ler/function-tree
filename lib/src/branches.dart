import "base.dart" show Node;
import "defs.dart" as defs;
import "derivatives.dart" show derivativesMap;

/// Base class for nodes with a single child node.
abstract class Branch extends Node {
  /// The single child node.
  late final Node child;
}

/// A node representing a function with a single parameter.
class FunctionBranch extends Branch {
  FunctionBranch(this.name, Node child) {
    this.child = child;
  }

  /// The name of the function.
  final String name;

  @override
  num call(Map<String, num> variables) =>
      defs.oneParameterFunctionMap[name]!(child(variables));

  @override
  String toTeX() => defs.oneParameterFunctionLatexRepresentation[name]!
      .replaceAll("C", child.toTeX());

  @override
  String representation([int indent = 0]) {
    final tab = " " * indent;
    return "Function $name:\n$tab  ${child.representation(indent + 2)}";
  }

  @override
  Node derivative(String variableName) {
    if (derivativesMap.containsKey(name)) {
      return derivativesMap[name]!(this, variableName);
    }
    throw UnimplementedError("Derivative of $name not implemented.");
  }

  @override
  String toString() => "$name($child)";
}

/// A node representing parentheses.
class ParenthesisBranch extends Branch {
  ParenthesisBranch(Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => child(variables);

  @override
  String toTeX() => r"\left(C\right)".replaceAll("C", child.toTeX());

  @override
  String representation([int indent = 0]) {
    final tab = " " * indent;
    return "Parentheses:\n$tab  ${child.representation(indent + 2)}";
  }

  @override
  Node derivative(String variableName) =>
      ParenthesisBranch(child.derivative(variableName));

  @override
  String toString() => "($child)";
}

/// A node representing the negation of an expression.
class NegationBranch extends Branch {
  NegationBranch(Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => -child(variables);

  @override
  String toTeX() => "-${child.toTeX()}";

  @override
  String representation([int indent = 0]) {
    final tab = " " * indent;
    return "Negation:\n$tab  ${child.representation(indent + 2)}";
  }

  @override
  Node derivative(String variableName) =>
      NegationBranch(child.derivative(variableName));

  @override
  String toString() => "-$child";
}

/// A node representing the affirmation (unary +) of an expression.
class AffirmationBranch extends Branch {
  AffirmationBranch(Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => child(variables);

  @override
  String toTeX() => "+${child.toTeX()}";

  @override
  String representation([int indent = 0]) {
    final tab = " " * indent;
    return "Affirmation:\n$tab  ${child.representation(indent + 2)}";
  }

  @override
  Node derivative(String variableName) => child.derivative(variableName);

  @override
  String toString() => "+$child";
}
