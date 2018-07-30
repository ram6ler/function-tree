import 'package:function_tree/function_tree.dart';
import 'dart:math' show pi;

void main() {
  var f = new FunctionTree(fromExpression: "sin(a) + cos(2 * b)", withVariableNames: ["a", "b"]);

  print(f({"a": pi / 4, "b": pi / 3}));
}
