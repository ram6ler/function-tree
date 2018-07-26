part of function_tree;

abstract class _Fork extends _Node {
  _Node left, right;
}

class _SumFork extends _Fork {
  _SumFork(_Node left, _Node right) {
    this
      ..left = left
      ..right = right;
  }

  @override
  num call(_) => left(_) + right(_);

  @override
  String toLaTeX() => "${left.toLaTeX()} + ${right.toLaTeX()} ";
}

class _DifferenceFork extends _Fork {
  _DifferenceFork(_Node left, _Node right) {
    this
      ..left = left
      ..right = right;
  }

  @override
  num call(_) => left(_) - right(_);

  @override
  String toLaTeX() => "${left.toLaTeX()} - ${right.toLaTeX()} ";
}

class _ProductFork extends _Fork {
  _ProductFork(_Node left, _Node right) {
    this
      ..left = left
      ..right = right;
  }

  @override
  num call(_) => left(_) * right(_);

  @override
  String toLaTeX() =>
      r"L \cdot R ".replaceAll("L", left.toLaTeX()).replaceAll("R", right.toLaTeX());
}

class _QuotientFork extends _Fork {
  _QuotientFork(_Node left, _Node right) {
    this
      ..left = left
      ..right = right;
  }

  @override
  num call(_) => left(_) / right(_);

  @override
  String toLaTeX() =>
      r"\frac{L}{R} ".replaceAll("L", left.toLaTeX()).replaceAll("R", right.toLaTeX());
}

class _PowerFork extends _Fork {
  _PowerFork(_Node left, _Node right) {
    this
      ..left = left
      ..right = right;
  }

  @override
  num call(_) => pow(left(_), right(_));

  @override
  String toLaTeX() => r"L^{R} ".replaceAll("L", left.toLaTeX()).replaceAll("R", right.toLaTeX());
}
