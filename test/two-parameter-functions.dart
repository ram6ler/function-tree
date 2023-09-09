import "package:function_tree/function_tree.dart";

void main() {
  final f = "log(3, x)".toSingleVariableFunction();
  print(f(9));
  print(f.tex);
  print(f.representation);
  print("-" * 50);

  final g = "pow(x, y)".toMultiVariableFunction(["x", "y"]);
  print(g({"x": 2, "y": 3}));
  print(g.tex);
  print(g.representation);
  print("-" * 50);
}
