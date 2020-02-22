part of function_tree;

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

_Node _parseString(String expression, List<String> variables) {
  // Check if numerical constant.
  {
    final x = num.tryParse(expression);
    if (x != null) {
      return _ConstantLeaf(x);
    }
  }

  // Check if a special constant.
  {
    // Allow user to override special constants.
    if (_constantMap.containsKey(expression) &&
        !variables.contains(expression)) {
      return _SpecialConstantLeaf(expression);
    }
  }

  // Check if a variable.
  {
    for (final variable in variables) {
      if (variable == expression) {
        return _VariableLeaf(variable);
      }
    }
  }

  // Check if unary -.
  if (expression[0] == '-') {
    return _NegativeBranch(_parseString(expression.substring(1), variables));
  }

  // Check if unary +.
  if (expression[0] == '+') {
    return _PositiveBranch(_parseString(expression.substring(1), variables));
  }

  // Check if parentheses.
  if (expression[0] == '(') {
    final end = _indexOfClosingParenthesis(expression);
    if (end == expression.length - 1) {
      return _ParenthesisBranch(
          _parseString(expression.substring(1, end), variables));
    }
  }

  // Check if a function.
  for (final key in _functionMap.keys) {
    final argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key) {
      if (expression[argumentIndex] == '(') {
        final end = _indexOfClosingParenthesis(expression, argumentIndex);
        if (end == expression.length - 1) {
          return _FunctionBranch(key,
              _parseString(expression.substring(argumentIndex), variables));
        }
      }
    }
  }

  // Helper for binary operations implementation.
  List<String> _leftRight(String operation) {
    if (expression.contains(operation)) {
      final split = expression.split(operation);
      for (var i = 1; i < split.length; i++) {
        final left = split.sublist(0, i).join(operation),
            right = split.sublist(i).join(operation);
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
  _Node _binaryOperationCheck(String character, String nodeName,
      _Node Function(_Node left, _Node right) generator) {
    final lr = _leftRight(character);
    if (lr == null) return null;

    return generator(
        _parseString(lr[0], variables), _parseString(lr[1], variables));
  }

  // Check if +.
  {
    final sumCheck = _binaryOperationCheck(
        '+', 'Sum Fork', (left, right) => _SumFork(left, right));
    if (sumCheck != null) {
      return sumCheck;
    }
  }

  // Check if -.
  {
    final diffCheck = _binaryOperationCheck(
        '-', 'Difference Fork', (left, right) => _DifferenceFork(left, right));
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

  throw Exception('Bad expression: \'$expression\'...');
}
