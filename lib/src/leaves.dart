part of function_tree;

class _ConstantLeaf extends _Node {
  _ConstantLeaf(this.value) {}
  num value;

  @override
  num call(_) => value;

  @override
  toLaTeX() => "$value ";
}

class _SpecialConstantLeaf extends _Node {
  _SpecialConstantLeaf(this.symbol) {
    value = _constantMap[symbol];
  }
  String symbol;
  num value;

  @override
  num call(_) => value;

  @override
  toLaTeX() => _constantLatexRepresentation[symbol];
}

class _VariableLeaf extends _Node {
  _VariableLeaf(this.symbol);
  String symbol;
  @override
  num call(_) => _[symbol];

  @override
  String toLaTeX() => "$symbol ";
}
