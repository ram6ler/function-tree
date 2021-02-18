part of function_tree;

/// A mapping of string representations to two-parameter functions.
final Map<String, num Function(num, num)> _twoParameterFunctionMap = {
  'log': (num b, num x) => log(x) / log(b),
  'nrt': (num n, num x) => pow(x, 1 / n),
  'pow': (num x, num p) => pow(x, p)
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> _twoParameterFunctionLatexRepresentation = {
  'log': r'\log_{C1}\left(C2\right)',
  'nrt': r'\sqrt[C1]{C2}',
  'pow': r'{C1}^{C2}'
};

/// A mapping of string representations to functions.
final Map<String, num Function(num)> _oneParameterFunctionMap = {
  'abs': (num x) => x.abs(),
  'acos': acos,
  'asin': asin,
  'atan': atan,
  'ceil': (num x) => x.ceil(),
  'cos': cos,
  'cosh': (num x) => (pow(e, x) + pow(e, -x)) / 2,
  'cot': (num x) => 1 / tan(x),
  'coth': (num x) => (pow(e, x) + pow(e, -x)) / (pow(e, x) - pow(e, -x)),
  'csc': (num x) => 1 / sin(x),
  'csch': (num x) => 2 / (pow(e, x) - pow(e, -x)),
  'exp': exp,
  'floor': (num x) => x.floor(),
  'ln': log,
  'log': log,
  'round': (num x) => x.round(),
  'sec': (num x) => 1 / cos(x),
  'sech': (num x) => 2 / (pow(e, x) + pow(e, -x)),
  'sin': sin,
  'sinh': (num x) => (pow(e, x) - pow(e, -x)) / 2,
  'sqrt': sqrt,
  'tan': tan,
  'tanh': (num x) => (pow(e, x) - pow(e, -x)) / (pow(e, x) + pow(e, -x))
};

/// A mapping of string representations of functions to LaTeX.
final Map<String, String> _oneParameterFunctionLatexRepresentation = {
  'abs': r'\left| C \right| ',
  'acos': r'\arccos\left( C \right) ',
  'asin': r'\arcsin\left( C \right) ',
  'atan': r'\arctan\left( C \right) ',
  'ceil': r'\lceil C \rceil ',
  'cos': r'\cos\left( C \right) ',
  'cosh': r'\cosh\left( C \right) ',
  'cot': r'\cot\left( C \right) ',
  'coth': r'\coth\left( C \right) ',
  'csc': r'\csc\left( C \right) ',
  'csch': r'\csch\left( C \right) ',
  'exp': r'\exp\left( C \right) ',
  'floor': r'\lfloor C \rfloor ',
  'ln': r'\ln\left( C \right) ',
  'log': r'\log\left( C \right) ',
  'round': r'\left[ C \right] ',
  'sec': r'\sec\left( C \right) ',
  'sech': r'\sech\left( C \right) ',
  'sin': r'\sin\left( C \right) ',
  'sinh': r'\sinh\left( C \right) ',
  'sqrt': r'\sqrt{ C } ',
  'tan': r'\tan\left( C \right) ',
  'tanh': r'\tanh\left( C \right) '
};

/// A mapping of string representations to constants.
final Map<String, num> _constantMap = {
  'E': e,
  'PI': pi,
  'LN2': ln2,
  'LN10': ln10,
  'LOG2E': log2e,
  'LOG10E': log10e,
  'SQRT1_2': sqrt1_2,
  'SQRT2': sqrt2,
  'e': e,
  'pi': pi,
  'ln2': ln2,
  'ln10': ln10,
  'log2e': log2e,
  'log10e': log10e,
  'sqrt1_2': sqrt1_2,
  'sqrt2': sqrt2,
};

/// A mapping of string representations of constants to LaTeX.
final Map<String, String> _constantLatexRepresentation = {
  'E': 'e ',
  'LN2': r'\ln 2 ',
  'LN10': r'\ln 10 ',
  'LOG2E': r'\log_2e ',
  'LOG10E': r'\log_{10} e ',
  'PI': r'\pi ',
  'SQRT1_2': r'\frac{\sqrt2}{2} ',
  'SQRT2': r'\sqrt{2} ',
  'e': 'e ',
  'ln2': r'\ln 2 ',
  'ln10': r'\ln 10 ',
  'log2e': r'\log_2e ',
  'log10e': r'\log_{10} e ',
  'pi': r'\pi ',
  'sqrt1_2': r'\frac{\sqrt2}{2} ',
  'sqrt2': r'\sqrt{2} '
};
