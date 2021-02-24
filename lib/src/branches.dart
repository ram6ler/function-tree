part of function_tree;

abstract class _Branch extends _Node {
  late _Node child;
}

class _FunctionBranch extends _Branch {
  _FunctionBranch(this.symbol, _Node child) {
    this.child = child;
  }
  String symbol;

  @override
  num call(Map<String, num> variables) =>
      _oneParameterFunctionMap[symbol]!(child(variables));

  @override
  String toTeX() => _oneParameterFunctionLatexRepresentation[symbol]!
      .replaceAll('C', child.toTeX());
}

class _ParenthesisBranch extends _Branch {
  _ParenthesisBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => child(variables);

  @override
  String toTeX() => r'\left(C\right)'.replaceAll('C', child.toTeX());
}

class _NegativeBranch extends _Branch {
  _NegativeBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => -child(variables);

  @override
  String toTeX() => '-${child.toTeX()}';
}

class _PositiveBranch extends _Branch {
  _PositiveBranch(_Node child) {
    this.child = child;
  }

  @override
  num call(Map<String, num> variables) => child(variables);

  @override
  String toTeX() => '+${child.toTeX()}';
}
