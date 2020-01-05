part of function_tree;

class _ConstantLeaf extends _Node {
  _ConstantLeaf(this.value) {}
  num value;

  @override
  num call(Map<String, num> _)  => value;

  @override
  toTeX() => '$value ';
}

class _SpecialConstantLeaf extends _Node {
  _SpecialConstantLeaf(this.symbol) {
    value = _constantMap[symbol];
  }
  String symbol;
  num value;

  @override
  num call(Map<String, num> _)  => value;

  @override
  toTeX() => _constantLatexRepresentation[symbol];
}

class _VariableLeaf extends _Node {
  _VariableLeaf(this.symbol);
  String symbol;
  @override
  num call(Map<String, num> variables)  => variables[symbol];

  @override
  String toTeX() => '$symbol ';
}
