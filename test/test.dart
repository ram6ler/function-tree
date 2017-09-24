// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:function_tree/function_tree.dart';
import 'dart:io';
import 'dart:math' show PI;

main() {
  // one variable...
  {
    var f = new FunctionOfX("1.5 * sin(2 * (x - PI / 3)) + 2");
    print(f(PI));
    print("TeX: ${f.tex}");
  }

  // two variable...
  {
    var ft = new FunctionTree(
        fromExpression: "x + y^2 / 2", withVariableNames: ["x", "y"]);
    for (int y = 0; y < 5; y++) {
      for (int x = 0; x < 5; x++) {
        stdout.write("${ft({"x": x, "y": y})}\t");
      }
      stdout.writeln();
    }
    print("tex: ${ft.tex}");
  }
}
