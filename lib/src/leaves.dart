part of function_tree;

class _ConstantLeaf extends _Node {
  _ConstantLeaf(this.value);
  num value;

  @override
  num call(Map<String, num> _) => value;

  @override
  String toTeX() => '$value ';
}

class _SpecialConstantLeaf extends _Node {
  _SpecialConstantLeaf(this.constant) {
    value = _constantMap[constant];
  }
  String constant;
  num value;

  @override
  num call(Map<String, num> _) => value;

  @override
  String toTeX() => _constantLatexRepresentation[constant];
}

class _VariableLeaf extends _Node {
  _VariableLeaf(this.variable);
  String variable;
  @override
  num call(Map<String, num> variables) => variables[variable];

  @override
  String toTeX() => '$variable ';
}
