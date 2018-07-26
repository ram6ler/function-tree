part of function_tree;

abstract class _Branch extends _Node {
  _Node child;
}

class _FunctionBranch extends _Branch {
  _FunctionBranch(this.symbol, _Node child) {
    this.child = child;
    function = _functionMap[symbol];
  }
  String symbol;
  num Function(num) function;

  @override
  num call(_) => function(child(_));

  @override
  String toLaTeX() => _functionLatexRepresentation[symbol].replaceAll("C", child.toLaTeX());
}

class _ParenthesisBranch extends _Branch {
  _ParenthesisBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(_) => child(_);

  @override
  String toLaTeX() => r"\left(C\right)".replaceAll("C", child.toLaTeX());
}

class _NegativeBranch extends _Branch {
  _NegativeBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(_) => -child(_);

  @override
  String toLaTeX() => "-${child.toLaTeX()}";
}

class _PositiveBranch extends _Branch {
  _PositiveBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(_) => child(_);

  @override
  String toLaTeX() => "+${child.toLaTeX()}";
}
