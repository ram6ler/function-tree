part of function_tree;

/// Verbose tree construction.
bool verboseTreeConstruction = false;

// Definitions

/// A mapping of string representations to functions.
final Map<String, Function> _functionMap = {
  "abs": (num x) => x.abs(),
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
  "sinh": (num x) => (pow(e, x) - pow(e, -x)) / 2,
  "cosh": (num x) => (pow(e, x) + pow(e, -x)) / 2,
  "tanh": (num x) => (pow(e, x) - pow(e, -x)) / (pow(e, x) + pow(e, -x)),
  "sech": (num x) => 2 / (pow(e, x) + pow(e, -x)),
  "csch": (num x) => 2 / (pow(e, x) - pow(e, -x)),
  "coth": (num x) => (pow(e, x) + pow(e, -x)) / (pow(e, x) - pow(e, -x)),
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
  "sqrt": r"\sqrt{C} ",
  "abs": r"\left|C\right| "
};

/// A mapping of string representations to constants.
final Map<String, num> _constantMap = {
  "E": e,
  "PI": pi,
  "π": pi,
  "LN2": ln2,
  "LN10": ln10,
  "LOG2E": log2e,
  "LOG10E": log10e,
  "SQRT1_2": sqrt1_2,
  "SQRT2": sqrt2,
  "e": e,
  "pi": pi,
  "ln2": ln2,
  "ln10": ln10,
  "log2e": log2e,
  "log10e": log10e,
  "sqrt1_2": sqrt1_2,
  "sqrt2": sqrt2,
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
  "SQRT2": r"\sqrt2 ",
  "e": "e ",
  "pi": r"\pi ",
  "ln2": r"\ln2 ",
  "ln10": r"\ln10 ",
  "log2e": r"\log_2e ",
  "log10e": r"\log_{10}e ",
  "sqrt1_2": r"\frac{\sqrt2}2 ",
  "sqrt2": r"\sqrt2 "
};
