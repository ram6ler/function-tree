part of function_tree;

int _indexOfClosingParenthesis(String expression, [int start = 0]) {
  int level = 0;
  for (int i = start; i < expression.length; i++) {
    if (expression[i] == "(")
      level++;
    else if (expression[i] == ")") {
      level--;
      if (level == 0) return i;
    }
  }
  return -1;
}

bool _parenthesesAreBalanced(String expression) {
  int level = 0;
  for (int i = 0; i < expression.length; i++) {
    if (expression[i] == "(")
      level++;
    else if (expression[i] == ")") level--;
  }

  return level == 0;
}

_Node _parseString(String expression, List<String> variables) {
  // Terminations...
  if (verboseTreeConstruction) print("Parsing '$expression'...");

  // Check if numerical constant.
  {
    num x = num.tryParse(expression);
    if (x != null) {
      if (verboseTreeConstruction) print("Constant Leaf: '$expression'");
      return _ConstantLeaf(x);
    }
  }

  // Check if a special constant.
  {
    // Allow user to override special constants.
    if (_constantMap.keys
        .any((key) => key == expression && !variables.contains(expression))) {
      if (verboseTreeConstruction)
        print("Special Constant Leaf: '$expression'");
      return _SpecialConstantLeaf(expression);
    }
  }

  // Check if a variable.
  {
    for (var variable in variables) {
      if (variable == expression) {
        if (verboseTreeConstruction) print("Variable Leaf: '$expression'");
        return _VariableLeaf(variable);
      }
    }
  }

  // Recursives...

  // Check if unary -.
  if (expression[0] == "-") {
    if (verboseTreeConstruction) print("Negative Branch: '$expression'");
    return _NegativeBranch(_parseString(expression.substring(1), variables));
  }

  // Check if unary +.
  if (expression[0] == "+") {
    if (verboseTreeConstruction) print("Positive Branch: '$expression'");
    return _PositiveBranch(_parseString(expression.substring(1), variables));
  }

  // Check if parentheses.
  if (expression[0] == "(") {
    int end = _indexOfClosingParenthesis(expression);
    if (end == expression.length - 1) {
      if (verboseTreeConstruction) print("Parentheses: '$expression'");
      return _ParenthesisBranch(
          _parseString(expression.substring(1, end), variables));
    }
  }

  // Check if a function.
  for (var key in _functionMap.keys) {
    int argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key) {
      if (expression[argumentIndex] == "(") {
        int end = _indexOfClosingParenthesis(expression, argumentIndex);
        if (end == expression.length - 1) {
          if (verboseTreeConstruction) print("Function Branch: '$expression'");
          return _FunctionBranch(key,
              _parseString(expression.substring(argumentIndex), variables));
        }
      }
    }
  }

  // Helper for binary operations implementations.
  List<String> _leftRight(String operation) {
    if (expression.contains(operation)) {
      var split = expression.split(operation);
      for (int i = 1; i < split.length; i++) {
        var left = split.sublist(0, i).join(operation),
            right = split.sublist(i).join(operation);
        if (_parenthesesAreBalanced(left) && _parenthesesAreBalanced(right)) {
          return [left, right];
        }
      }
      return null;
    } else
      return null;
  }

  // Helper for binary operation definitions.
  _Node _binaryOperationCheck(String character, String nodeName,
      _Node Function(_Node left, _Node right) generator) {
    var lr = _leftRight(character);
    if (lr == null) return null;

    if (verboseTreeConstruction) print("$nodeName: '$expression'");

    return generator(
        _parseString(lr[0], variables), _parseString(lr[1], variables));
  }

  // Check if +.
  {
    var sumCheck = _binaryOperationCheck(
        "+", "Sum Fork", (left, right) => _SumFork(left, right));
    if (sumCheck != null) return sumCheck;
  }
  /*{
    var lr = _leftRight("+");
    if (lr != null) {
      if (verboseTreeConstruction) print("Sum Fork: '$expression'");
      return _SumFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  // Check if -.
  {
    var diffCheck = _binaryOperationCheck(
        "-", "Difference Fork", (left, right) => _DifferenceFork(left, right));
    if (diffCheck != null) return diffCheck;
  }
  /*{
    var lr = _leftRight("-");
    if (lr != null) {
      if (verboseTreeConstruction) print("Difference Fork: '$expression'");
      return _DifferenceFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  // Check if *.
  {
    var productCheck = _binaryOperationCheck(
        "*", "Product Fork", (left, right) => _ProductFork(left, right));
    if (productCheck != null) return productCheck;
  }
  /*{
    var lr = _leftRight("*");
    if (lr != null) {
      if (verboseTreeConstruction) print("Product Fork: '$expression'");
      return _ProductFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  // Check if /.
  {
    var quotientCheck = _binaryOperationCheck(
        "/", "Quotient Fork", (left, right) => _QuotientFork(left, right));
    if (quotientCheck != null) return quotientCheck;
  }
  /*{
    var lr = _leftRight("/");
    if (lr != null) {
      if (verboseTreeConstruction) print("Quotient Fork: '$expression'");
      return _QuotientFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  // Check if %.
  {
    var remainderCheck = _binaryOperationCheck(
        "%", "Remainder Fork", (left, right) => _RemainderFork(left, right));
    if (remainderCheck != null) return remainderCheck;
  }
  /*{
    var lr = _leftRight("%");
    if (lr != null) {
      if (verboseTreeConstruction) print("Quotient Fork: '$expression'");
      return _RemainderFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  // Check if ^.
  {
    var powerCheck = _binaryOperationCheck(
        "^", "Power Fork", (left, right) => _PowerFork(left, right));
    if (powerCheck != null) return powerCheck;
  }
  /*{
    var lr = _leftRight("^");
    if (lr != null) {
      if (verboseTreeConstruction) print("Power Fork: '$expression'");
      return _PowerFork(
          _parseString(lr[0], variables), _parseString(lr[1], variables));
    }
  }*/

  throw Exception("Bad expression: '$expression'...");
}
