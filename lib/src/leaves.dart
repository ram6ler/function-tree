// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of function_tree;

/// A tree node representing a terminus point in the tree.
class _Leaf extends _FunctionTree {
  _Leaf(List<String> variableNames) : super(variableNames);
}

// Leaves

/// A leaf node representing a variable.
class _VariableLeaf extends _Leaf {
  _VariableLeaf(String variable, List<String> variableNames)
      : super(variableNames) {
    //f = _identity;
    f = (variables) => variables[variableNames.indexOf(variable)];
    tex = "$variable ";
  }
  @override
  String toString() => tex;
}

/// A leaf node representing a constant.
class _ConstantLeaf extends _Leaf {
  _ConstantLeaf(num k, List<String> variableNames) : super(variableNames) {
    f = (_) => k;
    tex = "$k ";
  }
  @override
  String toString() => tex;
}

/// A leaf node representing a constant.
class _SpecialConstantLeaf extends _Leaf {
  _SpecialConstantLeaf(
      num k, String latexRepresentation, List<String> variableNames)
      : super(variableNames) {
    f = (_) => k;
    tex = "$latexRepresentation ";
  }
  @override
  String toString() => tex;
}
