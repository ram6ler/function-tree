import "base.dart" show Node;
import "interpreter.dart" show parseString;
import "helpers.dart" show cleanExpression, cleanTeX;

/// Parent for `SingleVariableFunction` and `MultiVariableFunction` classes.
abstract class FunctionTree {
  /// A TeX expression representing the tree.
  String get tex;

  /// A tree structure representation.
  String get representation;

  /// A callable tree representing the components of the function.
  Node get tree;
}

/// A callable class built from a string representation of a
/// multi-variable numerical function.
///
/// Two named arguments are required: `fromExpression` and `withVariables`.
///
/// **Example**
///
/// ```dart
/// import "package:function_tree/function_tree.dart";
///
/// void main() {
///   final expression = "x * cos(3 * y) + z",
///       f = MultiVariableFunction(
///         fromExpression: expression,
///         withVariables: ["x", "y", "z"],
///       ),
///       pi = "pi".interpret(),
///       x = 2.0,
///       y = pi / 4,
///       z = 0.5,
///       result = f({"x": x, "y": y, "z": z});
///   print("f($x, $y, $z) = $result");
/// }
/// ```
///
/// **Result**
///
/// ```text
/// f(2.0, 0.7853981633974483, 0.5) = -0.9142135623730949
/// ```
///

class MultiVariableFunction extends FunctionTree {
  MultiVariableFunction(
      {required String fromExpression, required List<String> withVariables})
      : _tree = parseString(cleanExpression(fromExpression), withVariables),
        _variablesToMap = List<String>.from(withVariables);

  MultiVariableFunction.fromNode(
      {required Node node, required List<String> withVariables})
      : _tree = node,
        _variablesToMap = List<String>.from(withVariables);

  final List<String> _variablesToMap;

  final Node _tree;
  Node get tree => _tree;

  num call(Map<String, num> variables) => _tree(Map<String, num>.fromIterable(
      variables.keys.where((key) => _variablesToMap.contains(key)),
      value: (key) => variables[key]!));

  @override
  String get tex => cleanTeX(_tree.toTeX());

  @override
  String get representation => _tree.representation();

  MultiVariableFunction partial(String variableName) =>
      MultiVariableFunction.fromNode(
        node: _tree.derivative(variableName),
        withVariables: _variablesToMap,
      );

  @override
  String toString() => _tree.toString();
}

/// A callable class built from a string representation of a
/// numerical function.
///
/// Two named arguments are required: `fromExpression` and `withVariable`.
///
/// **Example**
///
/// ```dart
/// import "package:function_tree/function_tree.dart";
///
/// void main() {
///   final expression = "a^2 + 3*a + 5",
///       f = SingleVariableFunction(
///         fromExpression: expression,
///         withVariable: "a",
///       ),
///       x = 2.0,
///       result = f(x);
///   print("f($x) = $result");
/// }
/// ```
///
/// **Result**
///
/// ```text
/// f(2.0) = 15.0
/// ```
///
class SingleVariableFunction extends FunctionTree {
  SingleVariableFunction(
      {required String fromExpression, String withVariable = "x"})
      : _tree = parseString(cleanExpression(fromExpression), [withVariable]),
        variable = withVariable;

  SingleVariableFunction.fromNode(
      {required Node node, String withVariable = "x"})
      : _tree = node,
        variable = withVariable;

  final Node _tree;
  Node get tree => _tree;

  String variable;

  num call(num x) => _tree({variable: x});

  @override
  String get tex => cleanTeX(_tree.toTeX());

  @override
  String get representation => _tree.representation();

  SingleVariableFunction derivative(String variableName) =>
      SingleVariableFunction.fromNode(
        node: _tree.derivative(variableName),
        withVariable: variable,
      );

  @override
  String toString() => _tree.toString();
}
