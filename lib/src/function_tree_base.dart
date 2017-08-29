// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

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

  //num call(List<num> vs) => tree(vs);
  num call(Map<String, num> vs) =>
      tree(_variablesToMap.map((v) => vs.containsKey(v) ? vs[v] : 0).toList());

  @override
  String toString() => tree.toString();
}
