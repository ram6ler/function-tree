part of function_tree;

String _cleanExpression(String expression) {
  return expression.replaceAll(RegExp(r"[^0-9a-zA-Z_.+\-/*^()]"), "");
}

/// A callable class built from a string representation of a
/// multivariable numerical function.
///
/// Example:
///
///     var f = FunctionTree(
///       fromExpression: "sin(a) + cos(dilation * a)",
///       withVariableNames: ["a", "dilation"]);
///
///     print(f({"a": pi / 4, "dilation": 2}));
///
class FunctionTree {
  FunctionTree({String fromExpression, List<String> withVariableNames}) {
    tree = _parseString(_cleanExpression(fromExpression), withVariableNames);
    _variablesToMap = List<String>.from(withVariableNames);
  }

  List<String> _variablesToMap;

  _Node tree;

  String get tex => tree.toLaTeX();

  num call(Map<String, num> vs) =>
      tree(Map<String, num>.fromIterable(vs.keys.where((key) => _variablesToMap.contains(key)),
          value: (key) => vs[key]));

  @override
  String toString() => tree.toString();
}

/// A callable class built from a string representation of a
/// numerical function.
///
/// Example:
///
///     var ft = FunctionOfX("1.5 * sin(2 * (x - pi / 3)) + 1");
///
///     // pi from dart:math
///     ft(pi / 2);
///
class FunctionOfX {
  FunctionOfX(String expression) {
    tree = _parseString(_cleanExpression(expression), ["x"]);
  }
  _Node tree;
  String get tex => tree.toLaTeX();

  num call(num x) => tree({"x": x});

  /// Provides an estimate of the derivative at [x].
  ///
  /// Example:
  ///
  ///     var f = FunctionOfX("x^2");
  ///     num d = f.nDerivative(3);
  ///
  num nDerivative(num x, {num delta: 1e-9}) => (this(x + delta / 2) - this(x - delta / 2)) / delta;

  /// Tries to provide an estimate of the zero near [guess].
  ///
  /// Uses Newton's method for iteratively improving the initial
  /// approximation of the zero.
  ///
  /// Example:
  ///
  ///     var f = FunctionOfX("x^2 - 2");
  ///     num x0 = f.nZero(1);
  ///
  num nZero(num guess, {num epsilon: 1e-9}) {
    int maxIterations = 100, iteration = 1;
    num error = this(guess).abs();
    while (error > epsilon && iteration < maxIterations) {
      iteration++;
      num y = this(guess);
      guess -= y / this.nDerivative(guess);
      error = y.abs();
    }
    if (iteration == maxIterations)
      return double.nan;
    else
      return guess;
  }

  /// Provides an estimate of the definite integral.
  ///
  /// Returns an estimate of the definite integral bound
  /// by [a] and [b], using Simpson's method.
  ///
  /// Example:
  ///
  ///     var f = FunctionOfX("x^2");
  ///     num i = f.nIntegral(0, 1);
  ///
  num nIntegral(num a, num b, {int n}) {
    n = n ?? 100;
    num delta = (b - a) / n;
    num sum1 = 0.0, sum2 = 0.0;
    for (num x = a + delta; x < b; x += delta) {
      if (x < b - delta) sum1 += this(x);
      sum2 += this(x - delta / 2);
    }
    return delta / 3 * (this(a) + this(b) + sum1 + 2 * sum2);
  }
}
