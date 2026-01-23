import 'package:function_tree/src/complex.dart';

/// Base class for tree nodes.
abstract class Node {
  num call(Map<String, num> variableValues);

  Complex complexCall(Map<String, Complex> variableValues);

  Node derivative(String variableName);

  /// A TeX expression representing the node.
  String toTeX();

  /// A tree diagram for exploring the structure of the tree.
  String representation([int indent = 0]);
}
