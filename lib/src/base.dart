part of function_tree;

abstract class _Node {
  num call(Map<String, num> variableValues);
  String toLaTeX();
}
