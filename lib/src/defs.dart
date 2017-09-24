// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of function_tree;

/// Verbose tree construction.
final bool debug = false;

// Definitions

/// A mapping of string representations to functions.
final Map<String, Function> _functionMap = {
  "acos": acos,
  "asin": asin,
  "atan": atan,
  "cos": cos,
  "sin": sin,
  "tan": tan,
  "sec": (num x) => 1 / cos(x),
  "csc": (num x) => 1 / sin(x),
  "cot": (num x) => 1 / tan(x),
  "exp": exp,
  "log": log,
  "ln": log,
  "sinh": (num x) => (pow(E, x) - pow(E, -x)) / 2,
  "cosh": (num x) => (pow(E, x) + pow(E, -x)) / 2,
  "tanh": (num x) => (pow(E, x) - pow(E, -x)) / (pow(E, x) + pow(E, -x)),
  "sech": (num x) => 2 / (pow(E, x) + pow(E, -x)),
  "csch": (num x) => 2 / (pow(E, x) - pow(E, -x)),
  "coth": (num x) => (pow(E, x) + pow(E, -x)) / (pow(E, x) - pow(E, -x)),
  "sqrt": sqrt
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> _functionLatexRepresentation = {
  "acos": r"\arccos\left(C\right) ",
  "asin": r"\arcsin\left(C\right) ",
  "atan": r"\arctan\left(C\right) ",
  "cos": r"\cos\left(C\right) ",
  "sin": r"\sin\left(C\right) ",
  "tan": r"\tan\left(C\right) ",
  "sec": r"\sec\left(C\right) ",
  "csc": r"\csc\left(C\right) ",
  "cot": r"\cot\left(C\right) ",
  "exp": r"\exp\left(C\right) ",
  "log": r"\log\left(C\right) ",
  "ln": r"\ln\left(C\right) ",
  "sinh": r"\sinh\left(C\right) ",
  "cosh": r"\cosh\left(C\right) ",
  "tanh": r"\tanh\left(C\right) ",
  "sech": r"\sech\left(C\right) ",
  "csch": r"\csch\left(C\right) ",
  "coth": r"\coth\left(C\right) ",
  "sqrt": r"\sqrt{C} "
};

/// A mapping of string representations to constants.
final Map<String, num> _constantMap = {
  "E": E,
  "PI": PI,
  "π": PI,
  "LN2": LN2,
  "LN10": LN10,
  "LOG2E": LOG2E,
  "LOG10E": LOG10E,
  "SQRT1_2": SQRT1_2,
  "SQRT2": SQRT2
};

/// A mapping of string representations of constants to LaTeX.
final Map<String, String> _constantLatexRepresentation = {
  "E": "e ",
  "PI": r"\pi ",
  "π": r"\pi ",
  "LN2": r"\ln2 ",
  "LN10": r"\ln10 ",
  "LOG2E": r"\log_2e ",
  "LOG10E": r"\log_{10}e ",
  "SQRT1_2": r"\frac{\sqrt2}2 ",
  "SQRT2": r"\sqrt2 "
};
