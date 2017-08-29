// Copyright (c) 2017, Richard Ambler. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of function_tree;

// Helpers

int _parenthesisEnd(String expression, int start) =>
    new RegExp(r"\(.*\)").allMatches(expression, start).first.end - 1;

String _replaceFromParenthesesList(String expression, List<String> list) {
  final indexPattern = new RegExp(r"\[[0-9]+\]");
  Match match;
  while ((match = indexPattern.firstMatch(expression)) != null) {
    int index = int.parse(expression.substring(match.start + 1, match.end - 1));
    String from = expression.substring(match.start, match.end);
    expression = expression.replaceFirst(from, list[index]);
  }
  return expression;
}

_FunctionTree _createFunctionTree(
    {String fromExpression, List<String> withVariableNames}) {
  var specialConstants = new List<String>();
  // Parser helper;
  _FunctionTree createTree(String expression) {
    // is the entire expression in parenthesis?
    {
      if (expression[0] == "(") {
        int end = _parenthesisEnd(expression, 0);
        if (end == expression.length - 1) {
          String childExpression = expression.substring(1, end);
          if (debug) print("<parenthesis>: '$childExpression");
          return new _ParenthesisBranch(
              createTree(childExpression), withVariableNames);
        }
      }
    }
    // is the expression of the form FUN(...)?
    {
      final functionPattern = new RegExp(r"^[a-z]+\(");
      Match match = functionPattern.firstMatch(expression);
      if (match != null) {
        int start = expression.indexOf("("),
            end = _parenthesisEnd(expression, start);
        if (end == expression.length - 1) {
          String functionKey = expression.substring(0, start),
              functionArgument = expression.substring(start + 1, end);
          if (debug) print("<function: $functionKey>: '$functionArgument'");
          return new _FunctionBranch(
              createTree(functionArgument),
              _functionMap[functionKey],
              _functionLatexRepresentation[functionKey],
              withVariableNames);
        }
      }
    }

    var expressionList = new List<String>();
    int expressionIndex = 0;
    // are there any parentheses?

    if (expression.contains("(")) {
      int i;
      for (i = expression.indexOf("("); i < expression.length; i++) {
        if (expression[i] == "(") {
          int j = _parenthesisEnd(expression, i);
          String expressionItem = expression.substring(i, j + 1);
          expressionList.add(expressionItem);
          expression =
              expression.replaceFirst(expressionItem, "[$expressionIndex]");
          expressionIndex++;

          if (!expression.contains("("))
            break;
          else {
            i = expression.indexOf("(") - 1;
            //print("... '$expression' $i ${expression.length}");
          }
        }
      }
    }

    // yet another helper...
    _FunctionTree createFork(String operatorCharacter,
        _FunctionTree Function(_FunctionTree, _FunctionTree) forkChoice) {
      int i = expression.indexOf(operatorCharacter);
      String leftExpression = _replaceFromParenthesesList(
              expression.substring(0, i), expressionList),
          rightExpression = _replaceFromParenthesesList(
              expression.substring(i + 1), expressionList);
      if (debug)
        print("'$leftExpression' <:$operatorCharacter:> '$rightExpression'");
      return forkChoice(
          createTree(leftExpression), createTree(rightExpression));
    }

    // check for sums
    if (expression.contains("+"))
      return createFork(
          "+",
          (leftChild, rightChild) =>
              new _SumFork(leftChild, rightChild, withVariableNames));

    // check for differences
    if (expression.contains("-"))
      return createFork(
          "-",
          (leftChild, rightChild) =>
              new _DifferenceFork(leftChild, rightChild, withVariableNames));

    // check for products
    if (expression.contains("*"))
      return createFork(
          "*",
          (leftChild, rightChild) =>
              new _ProductFork(leftChild, rightChild, withVariableNames));

    // check for quotients
    if (expression.contains("/"))
      return createFork(
          "/",
          (leftChild, rightChild) =>
              new _QuotientFork(leftChild, rightChild, withVariableNames));

    // check for powers
    if (expression.contains("^"))
      return createFork(
          "^",
          (leftChild, rightChild) =>
              new _PowerFork(leftChild, rightChild, withVariableNames));

    // check for variables
    if (withVariableNames.contains(expression)) {
      int variableIndex = withVariableNames.indexOf(expression);
      if (debug) print("<variable:> '${withVariableNames[variableIndex]}'");
      return new _VariableLeaf(expression, withVariableNames);
    }

    // yet another helper 2
    _FunctionTree createBranch(
        _FunctionTree Function(_FunctionTree) branchChoice) {
      String childExpression =
          _replaceFromParenthesesList(expression.substring(1), expressionList);
      return branchChoice(createTree(childExpression));
    }

    // check for negative
    if (expression[0] == "~") {
      if (debug) print("<negative:> '${expression.substring(1)}'");
      return createBranch(
          (child) => new _NegativeBranch(child, withVariableNames));
    }

    // check for positive
    if (expression[0] == "#") {
      if (debug) print("<positive:> '${expression.substring(1)}'");
      return createBranch(
          (child) => new _PositiveBranch(child, withVariableNames));
    }

    // check for special constant
    if (expression[0] == "<") {
      int constantIndex =
          int.parse(expression.substring(1, expression.length - 1));
      String constantKey = specialConstants[constantIndex];
      if (debug) print("<constant-special:> $constantIndex $constantKey");
      return new _SpecialConstantLeaf(_constantMap[constantKey],
          _constantLatexRepresentation[constantKey], withVariableNames);
    }

    // assume numeric constant
    if (debug) print("<constant:> $expression");
    return new _ConstantLeaf(num.parse(expression), withVariableNames);
  }

  // TODO: clean expression (check only allowed characters etc.)
  int constantIndex = 0;
  _constantMap.keys.forEach((String key) {
    while (fromExpression.contains(key)) {
      fromExpression = fromExpression.replaceFirst(key, "<$constantIndex>");
      specialConstants.add(key);
      constantIndex++;
    }
  });

  // remove spaces
  fromExpression = fromExpression.replaceAll(" ", "");

  // identify unary + and -
  String replaceIndex(int i, String symbol) =>
      "${fromExpression.substring(0, i)}$symbol${fromExpression.substring(i + 1)}";
  for (int i = 0; i < fromExpression.length; i++) {
    if (fromExpression[i] == "-") {
      if (i == 0 || fromExpression[i - 1] == "(")
        fromExpression = replaceIndex(i, "~");
    } else if (fromExpression[i] == "+") {
      if (i == 0 || fromExpression[i - 1] == "(")
        fromExpression = replaceIndex(i, "#");
    }
  }
  if (debug) print("Parsing: '$fromExpression'");

  // parse expression
  return createTree(fromExpression);
}
