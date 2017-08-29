// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:function_tree/function_tree.dart';
import 'package:test/test.dart';
import 'dart:math';

void main() {
  group('A group of tests', () {
    FunctionTree ft;
    num Function(num) f;
    setUp(() {
      ft = new FunctionTree(
          fromExpression: "1.5 * sin(2 * (x - PI / 3)) + 1",
          withVariableNames: ["x"]);
      f = (x) => 1.5 * sin(2 * (x - PI / 3)) + 1;
    });

    test('First Test', () {
      List<num> xs = new List<num>.generate(10, (i) => 1 / 10),
          f1 = xs.map(f).toList(),
          f2 = xs.map((x) => ft({"x": x})).toList();
      for (int i = 0; i < f1.length; i++) {
        expect(f1[i] == f2[i], isTrue);
      }
    });
  });
}
