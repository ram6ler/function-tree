part of function_tree;

final _debug = false;
void _message(String message) {
  if (_debug) {
    print(message);
  }
}

/// Returns the index of the closure of the parenthesis opening at `start`.
int _indexOfClosingParenthesis(String expression,
    [int start = 0, String open = '(', String close = ')']) {
  int level = 0, index;
  for (index = start; index < expression.length; index++) {
    if (expression.substring(index, index + open.length) == open) {
      level++;
      index += open.length - 1;
    } else if (expression.substring(index, index + close.length) == close) {
      level--;
      if (level == 0) {
        break;
      }
      index += close.length - 1;
    }
  }
  return level == 0 ? index : -1;
}

/// Checks whether all parentheses in `expression` are closed.
bool _parenthesesAreBalanced(String expression) {
  var level = 0;
  for (var i = 0; i < expression.length; i++) {
    if (expression[i] == '(') {
      level++;
    } else if (expression[i] == ')') {
      level--;
    }
  }
  return level == 0;
}

int _numberOfCommas(String expression) {
  if (expression.isEmpty) {
    return 0;
  }

  final index = expression.indexOf(',');
  if (index == -1) {
    return 0;
  }
  if (index == expression.length - 1) {
    return 1;
  }
  return 1 + _numberOfCommas(expression.substring(index + 1));
}

_Node _parseString(String expression, List<String> variables) {
  _message('Parsing "$expression"');

  // Check if numerical constant.
  {
    final x = double.tryParse(expression);
    if (x != null) {
      _message('  ...Constant Leaf: $expression');
      return _ConstantLeaf(x);
    }
  }

  // Check if a special constant.
  {
    // Allow user to override special constants.
    if (_constantMap.containsKey(expression) &&
        !variables.contains(expression)) {
      _message('  ... Special Constant Leaf: $expression');
      return _SpecialConstantLeaf(expression);
    }
  }

  // Check if a variable.
  {
    for (final variable in variables) {
      if (variable == expression) {
        _message('  ...Variable Leaf: $expression');
        return _VariableLeaf(variable);
      }
    }
  }

  // Check if parentheses.
  if (expression[0] == '(') {
    final end = _indexOfClosingParenthesis(expression);
    if (end == expression.length - 1) {
      _message('  ...Parenthesis Branch: $expression');
      return _ParenthesisBranch(
          _parseString(expression.substring(1, end), variables));
    }
  }

  // Check if a two-parameter function.
  for (final key in _twoParameterFunctionMap.keys) {
    final argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key &&
        _numberOfCommas(expression) == 1) {
      final commaIndex = expression.indexOf(','),
          end = _indexOfClosingParenthesis(expression, argumentIndex),
          firstArgument = expression.substring(argumentIndex + 1, commaIndex),
          secondArgument =
              expression.substring(commaIndex + 1, expression.length - 1);
      if (end == expression.length - 1) {
        _message('  ...Two Parameter Function Fork: $expression');
        return _TwoParameterFunctionFork(
            key,
            _parseString(firstArgument, variables),
            _parseString(secondArgument, variables));
      }
    }
  }

  // Check if a single-parameter function.
  for (final key in _oneParameterFunctionMap.keys) {
    final argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key) {
      if (expression[argumentIndex] == '(') {
        final end = _indexOfClosingParenthesis(expression, argumentIndex);
        if (end == expression.length - 1) {
          _message('  ...Function Branch: $expression');
          return _FunctionBranch(key,
              _parseString(expression.substring(argumentIndex), variables));
        }
      }
    }
  }

  // Helper for binary operations implementation.
  List<String>? _leftRight(String operation, String notPreceding) {
    if (expression.contains(operation)) {
      final split = expression.split(operation);
      for (var i = split.length - 1; i > 0; i--) {
        final left = split.sublist(0, i).join(operation),
            right = split.sublist(i).join(operation);
        if (left.isEmpty || notPreceding.contains(left[left.length - 1])) {
          return null;
        }
        if (_parenthesesAreBalanced(left) && _parenthesesAreBalanced(right)) {
          return [left, right];
        }
      }
      return null;
    } else {
      return null;
    }
  }

  // Helper for binary operation definition.
  _Node? _binaryOperationCheck(String character, String nodeName,
      _Node Function(_Node left, _Node right) generator,
      [String notPreceding = '']) {
    final leftRight = _leftRight(character, notPreceding);
    if (leftRight == null) {
      return null;
    }

    _message(
        '  ...$nodeName: $expression; left: ${leftRight.first}, right:${leftRight.last}');
    return generator(_parseString(leftRight[0], variables),
        _parseString(leftRight[1], variables));
  }

  // Check if +.
  {
    final sumCheck = _binaryOperationCheck(
        '+', 'Sum Fork', (left, right) => _SumFork(left, right), '/*^%');
    if (sumCheck != null) {
      return sumCheck;
    }
  }

  // Check if -.
  {
    final diffCheck = _binaryOperationCheck('-', 'Difference Fork',
        (left, right) => _DifferenceFork(left, right), '/*^%');
    if (diffCheck != null) {
      return diffCheck;
    }
  }

  // Check if *.
  {
    final productCheck = _binaryOperationCheck(
        '*', 'Product Fork', (left, right) => _ProductFork(left, right));
    if (productCheck != null) {
      return productCheck;
    }
  }

  // Check if /.
  {
    final quotientCheck = _binaryOperationCheck(
        '/', 'Quotient Fork', (left, right) => _QuotientFork(left, right));
    if (quotientCheck != null) {
      return quotientCheck;
    }
  }

  // Check if %.
  {
    final remainderCheck = _binaryOperationCheck(
        '%', 'Remainder Fork', (left, right) => _RemainderFork(left, right));
    if (remainderCheck != null) {
      return remainderCheck;
    }
  }

  // Check if ^.
  {
    final powerCheck = _binaryOperationCheck(
        '^', 'Power Fork', (left, right) => _PowerFork(left, right));
    if (powerCheck != null) {
      return powerCheck;
    }
  }

  // Check if unary -.
  if (expression[0] == '-') {
    _message('  ...Negative Branch -: $expression');
    return _NegativeBranch(_parseString(expression.substring(1), variables));
  }

  // Check if unary +.
  if (expression[0] == '+') {
    _message('  ...Positive Branch +: $expression');
    return _PositiveBranch(_parseString(expression.substring(1), variables));
  }

  throw Exception('Bad expression: \'$expression\'...');
}
