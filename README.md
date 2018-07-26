# function_tree

A library for parsing and evaluating mathematical functions built from strings.

## Usage

A simple usage example:

    import 'package:function_tree/function_tree.dart';
    import 'dart:math' show pi;

    main() {
      var f = FunctionOfX("1.5 * sin(2 * (x - pi / 3)) + 2");
      print(f(pi));

      var ft = FunctionTree(
        fromExpression: "1.5 * sin(2 * (x - pi / 3)^2) + y",
        withVariableNames: ["x", "y"]);

      print(ft({"x": 1, "y": 2}));
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://bitbucket.org/ram6ler/function-tree/issues


