// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:function_tree/function_tree.dart';

main() {
  FunctionTree ft = new FunctionTree(
      fromExpression: "1.5 * sin(2 * (x - PI / 3)^2) + y",
      withVariableNames: ["x", "y"]);

  print(ft({"x": 1, "y": 2}));
}
