// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of function_tree;

/// A tree node with two child nodes.
class _Fork extends _FunctionTree {
  _Fork(this.leftChild, this.rightChild, List<String> variableNames)
      : super(variableNames);
  _FunctionTree leftChild, rightChild;
  @override
  String toString() => tex
      .replaceFirst("L", leftChild.toString())
      .replaceFirst("R", rightChild.toString());
}

// Forks

/// A fork node representing a sum.
class _SumFork extends _Fork {
  _SumFork(_FunctionTree leftChild, _FunctionTree rightChild,
      List<String> variableNames)
      : super(leftChild, rightChild, variableNames) {
    f = (List<num> variables) => leftChild(variables) + rightChild(variables);
    tex = "L + R ";
  }
}

/// A fork node representing a difference.
class _DifferenceFork extends _Fork {
  _DifferenceFork(_FunctionTree leftChild, _FunctionTree rightChild,
      List<String> variableNames)
      : super(leftChild, rightChild, variableNames) {
    f = (List<num> variables) => leftChild(variables) - rightChild(variables);
    tex = "L - R ";
  }
}

/// A fork node representing a product.
class _ProductFork extends _Fork {
  _ProductFork(_FunctionTree leftChild, _FunctionTree rightChild,
      List<String> variableNames)
      : super(leftChild, rightChild, variableNames) {
    f = (List<num> variables) => leftChild(variables) * rightChild(variables);
    tex = r"L\cdot R ";
  }
}

/// A fork node representing a quotient.
class _QuotientFork extends _Fork {
  _QuotientFork(_FunctionTree leftChild, _FunctionTree rightChild,
      List<String> variableNames)
      : super(leftChild, rightChild, variableNames) {
    f = (List<num> variables) => leftChild(variables) / rightChild(variables);
    tex = r"\frac{L}{R} ";
  }
}

/// A fork node representing a power.
class _PowerFork extends _Fork {
  _PowerFork(_FunctionTree leftChild, _FunctionTree rightChild,
      List<String> variableNames)
      : super(leftChild, rightChild, variableNames) {
    f = (List<num> variables) =>
        pow(leftChild(variables), rightChild(variables));
    tex = "L^{R} ";
  }
}
