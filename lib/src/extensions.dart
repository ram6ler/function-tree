part of function_tree;

extension StringMethods on String {
  /// Generates a callable multi-variable function-tree.
  ///
  /// Example:
  ///
  ///     final sum = 'a + b'.toMultiVariableFunction(['a', 'b']);
  ///     print(sum({'a': 1, 'b': 2})); // 3
  ///
  MultiVariableFunction toMultiVariableFunction(List<String> variableNames) =>
      MultiVariableFunction(fromExpression: this, withVariables: variableNames);

  /// Generates a callable single variable function-tree.
  ///
  /// Example:
  ///
  ///     final f = '2 * e^x'.toSingleVariableFunction();
  ///     print(f(2)); // 14.778112197861299
  SingleVariableFunction toSingleVariableFunction(
          [String variableName = 'x']) =>
      SingleVariableFunction(fromExpression: this, withVariable: variableName);

  /// Evaluates the string as a mathematical expression.
  ///
  /// Example:
  ///
  ///     print('2 * pi'.interpret()); // 6.283185307179586
  num interpret() => toSingleVariableFunction()(0);
}
