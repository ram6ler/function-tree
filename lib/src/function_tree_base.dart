// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// A library for parsing and evaluating mathematical functions built from strings.
library function_tree;

import 'dart:math';

part 'defs.dart';
part 'base.dart';
part 'leaves.dart';
part 'branches.dart';
part 'forks.dart';
part 'parser.dart';

/// A callable, function-like class.
///
///
/// Example:
///
///     var ft = new FunctionTree(
///       fromExpression: "1.5 * sin(2 * (x - PI / 3)) + 1",
///       withVariableNames: ["x"]
///     );
///
///     // Note: function arguments in a list.
///     ft([PI / 2]);
///
class FunctionTree {
  FunctionTree({String fromExpression, List<String> withVariableNames}) {
    tree = _createFunctionTree(
        fromExpression: fromExpression, withVariableNames: withVariableNames);
    _variablesToMap = new List<String>.from(withVariableNames);
  }

  List<String> _variablesToMap;

  _FunctionTree tree;

  String get tex => tree.toString();

  //num call(List<num> vs) => tree(vs);
  num call(Map<String, num> vs) =>
      tree(_variablesToMap.map((v) => vs.containsKey(v) ? vs[v] : 0).toList());

  @override
  String toString() => tree.toString();
}

/// A callable, function-like class.
///
///
/// Example:
///
///     var ft = new FunctionOfX("1.5 * sin(2 * (x - PI / 3)) + 1");
///
///     ft(PI / 2);
///
class FunctionOfX {
  FunctionOfX(String expression) {
    tree = _createFunctionTree(
        fromExpression: expression, withVariableNames: ["x"]);
  }
  _FunctionTree tree;
  String get tex => tree.toString();

  num call(num x) => tree([x]);

  /// Provides an estimate of the derivative at [x].
  ///
  /// Example:
  ///
  ///     var f = new FunctionOfX("x^2");
  ///     num d = f.nDerivative(3);
  ///
  num nDerivative(num x, {num delta: 1e-9}) =>
      (this(x + delta / 2) - this(x - delta / 2)) / delta;

  /// Tries to provide as estimate of the zero near [guess].
  ///
  /// Uses Newton's method for iteratively improving the initial
  /// approximation of the zero.
  ///
  /// Example:
  ///
  ///     var f = new FunctionOfX("x^2 - 2");
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
      return double.NAN;
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
  ///     var f = new FunctionOfX("x^2");
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
