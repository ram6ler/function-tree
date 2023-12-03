import "base.dart" show Node;
import "defs.dart" as defs;

abstract class Leaf extends Node {}

/// A node representing a numeric constant.
class ConstantLeaf extends Leaf {
  static final ConstantLeaf zero = ConstantLeaf(0.0);
  static final ConstantLeaf one = ConstantLeaf(1.0);

  ConstantLeaf(this.value);
  final num value;

  @override
  num call(Map<String, num> _) => value;

  @override
  String toTeX() => "$value ";

  @override
  String representation([int indent = 0]) => "Constant $value";

  @override
  Node derivative(String _) => ConstantLeaf.zero;

  @override
  String toString() => value.toString();
}

//// A node representing a special numeric constant.
class SpecialConstantLeaf extends Leaf {
  SpecialConstantLeaf(this.constant) : value = defs.constantMap[constant]!;

  final String constant;
  final num value;

  @override
  num call(Map<String, num> _) => value;

  @override
  String toTeX() => defs.constantLatexRepresentation[constant]!;

  @override
  String representation([int indent = 0]) => "Special Constant $constant";

  @override
  Node derivative(String _) => ConstantLeaf.zero;

  @override
  String toString() => constant;
}

//// A node representing a variable.
class VariableLeaf extends Leaf {
  VariableLeaf(this.variable);

  final String variable;

  @override
  num call(Map<String, num> variables) => variables[variable]!;

  @override
  String toTeX() => "$variable ";

  @override
  String representation([int indent = 0]) => "Variable $variable";

  @override
  Node derivative(String variableName) =>
      variableName == variable ? ConstantLeaf.one : ConstantLeaf.zero;

  @override
  String toString() => variable;
}
