import "base.dart" show Node;
import "branches.dart"
    show ParenthesisBranch, FunctionBranch, NegationBranch, AffirmationBranch;
import "forks.dart"
    show
        DifferenceFork,
        PowerFork,
        ProductFork,
        QuotientFork,
        ModulusFork,
        SumFork,
        TwoParameterFunctionFork;
import "leaves.dart" show Leaf, ConstantLeaf, SpecialConstantLeaf, VariableLeaf;
import "helpers.dart"
    show indexOfClosingParenthesis, numberOfCommas, parenthesesAreBalanced;
import "defs.dart" as defs;

/// Generates a callable function tree from `expression`.
Node parseString(String expression, List<String> variables) {
  // Check if numerical constant.
  {
    final x = double.tryParse(expression);
    if (x != null) {
      return ConstantLeaf(x);
    }
  }

  // Check if a special constant.
  // (Allow user to override special constants.)
  if (defs.constantMap.containsKey(expression) &&
      !variables.contains(expression)) {
    return SpecialConstantLeaf(expression);
  }

  // Check if a variable.
  for (final variable in variables) {
    if (variable == expression) {
      return VariableLeaf(variable);
    }
  }

  // Check if parentheses.
  if (expression[0] == "(") {
    final end = indexOfClosingParenthesis(expression);
    if (end == expression.length - 1) {
      final childExpression = expression.substring(1, end),
          peekAhead = parseString(childExpression, variables);
      switch (peekAhead) {
        case ParenthesisBranch() ||
              Leaf() ||
              FunctionBranch() ||
              TwoParameterFunctionFork() ||
              ProductFork() ||
              QuotientFork() ||
              ModulusFork() ||
              PowerFork():
          // Drop the outer parenthesis.
          return peekAhead;
        case _:
          return ParenthesisBranch(peekAhead);
      }
    }
  }

  // Check if special negation.
  if (expression[0] == "~") {
    return NegationBranch(parseString(expression.substring(1), variables));
  }

  // Check if a two-parameter function.
  for (final key in defs.twoParameterFunctionMap.keys) {
    final argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key &&
        numberOfCommas(expression) == 1) {
      final commaIndex = expression.indexOf(","),
          end = indexOfClosingParenthesis(expression, argumentIndex),
          firstArgument = expression.substring(argumentIndex + 1, commaIndex),
          secondArgument =
              expression.substring(commaIndex + 1, expression.length - 1);
      if (end == expression.length - 1) {
        final leftPeekAhead = parseString(firstArgument, variables),
            leftChild = switch (leftPeekAhead) {
              ParenthesisBranch() => leftPeekAhead.child,
              _ => leftPeekAhead
            },
            rightPeekAhead = parseString(secondArgument, variables),
            rightChild = switch (rightPeekAhead) {
              ParenthesisBranch() => rightPeekAhead.child,
              _ => rightPeekAhead
            };
        return TwoParameterFunctionFork(key, leftChild, rightChild);
      }
    }
  }

  // Check if a single-parameter function.
  for (final key in defs.oneParameterFunctionMap.keys) {
    final argumentIndex = key.length;
    if (expression.length >= argumentIndex &&
        expression.substring(0, argumentIndex) == key) {
      if (expression[argumentIndex] == "(") {
        final end = indexOfClosingParenthesis(expression, argumentIndex);
        if (end == expression.length - 1) {
          final childExpression = expression.substring(argumentIndex),
              peekAhead = parseString(childExpression, variables);
          switch (peekAhead) {
            case ParenthesisBranch():
              // Drop parentheses containing full argument argument.
              return FunctionBranch(key, peekAhead.child);
            case _:
              return FunctionBranch(key, peekAhead);
          }
        }
      }
    }
  }

  // Helper for binary operations implementation.
  (String, String)? leftRight(String operation, String notPreceding) {
    if (expression.contains(operation)) {
      final split = expression.split(operation);
      for (var i = split.length - 1; i > 0; i--) {
        final left = split.sublist(0, i).join(operation),
            right = split.sublist(i).join(operation);
        if (left.isEmpty || notPreceding.contains(left[left.length - 1])) {
          return null;
        }
        if (parenthesesAreBalanced(left) && parenthesesAreBalanced(right)) {
          return (left, right);
        }
      }
      return null;
    } else {
      return null;
    }
  }

  // Helper for binary operation definition.
  Node? binaryOperation(
      String character,
      String nodeName,
      Node Function(
        Node left,
        Node right,
      ) generator,
      [String notPreceding = ""]) {
    final operands = leftRight(character, notPreceding);
    if (operands == null) {
      return null;
    }

    final (String left, String right) = operands;
    return generator(
        parseString(left, variables), parseString(right, variables));
  }

  // Check if +.
  {
    final sum = binaryOperation(
        "+", "Sum Fork", (left, right) => SumFork(left, right), "/*^%");
    if (sum != null) {
      return sum;
    }
  }

  // Check if -.
  {
    final difference = binaryOperation("-", "Difference Fork",
        (left, right) => DifferenceFork(left, right), "/*^%");
    if (difference != null) {
      return difference;
    }
  }

  // Check if *.
  {
    final product = binaryOperation(
        "*", "Product Fork", (left, right) => ProductFork(left, right));
    if (product != null) {
      return product;
    }
  }

  // Check if /.
  {
    final quotient = binaryOperation(
        "/", "Quotient Fork", (left, right) => QuotientFork(left, right));
    if (quotient != null) {
      return quotient;
    }
  }

  // Check if %.
  {
    final modulus = binaryOperation(
        "%", "Modulus Fork", (left, right) => ModulusFork(left, right));
    if (modulus != null) {
      return modulus;
    }
  }

  // Check if ^.
  {
    final power = binaryOperation(
        "^", "Power Fork", (left, right) => PowerFork(left, right));
    if (power != null) {
      return power;
    }
  }

  if (expression[0] == "-") {
    final childExpression = expression.substring(1),
        peekAhead = parseString(childExpression, variables);
    switch (peekAhead) {
      case NegationBranch():
        // Drop double negations.
        return peekAhead.child;
      case ConstantLeaf(value: num v):
        // Replace negations of constants with negative constants.
        return ConstantLeaf(-v);
      case _:
        return NegationBranch(peekAhead);
    }
  }

  // Check if unary +.
  if (expression[0] == "+") {
    return AffirmationBranch(parseString(expression.substring(1), variables));
  }

  throw FormatException("Bad expression: \"$expression\"...");
}
