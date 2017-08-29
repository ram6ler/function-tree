// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of function_tree;

// Base class.
class _FunctionTree {
  _FunctionTree(this.variableNames);

  // The symbols to be treated as variables.
  List<String> variableNames;

  // A TeX representation of the expression.
  String tex;

  // The function wrapped by a tree node.
  num Function(List<num>) f;

  num call(List<num> variables) => f(variables);
}
