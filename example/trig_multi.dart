// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:function_tree/function_tree.dart';
import 'dart:math' show PI;

void main() {
  var f = new FunctionTree(
      fromExpression: "sin(a) + cos(2 * b)", withVariableNames: ["a", "b"]);

  print(f({"a": PI / 4, "b": PI / 3}));
}
