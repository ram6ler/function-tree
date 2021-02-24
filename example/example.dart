import 'package:function_tree/function_tree.dart';
import 'dart:math' show pi;

void main() {
  // FunctionOfX...
  var f = SingleVariableFunction(
          fromExpression: 'abs(sin(x)) + cos(abs(x)) / 2'),
      n = 50,
      xs = List.generate(n + 1, (i) => -pi + i * 2 * pi / n),
      ys = xs.map(f);

  // A rough sketch of the graph of this function over [-π, π].
  print('\nA rough plot of \$${f.tex}\$:\n\n```');
  ys.map((y) => '|${' ' * (y * 50).round()}+').forEach(print);

  // FunctionTree
  var tree = MultiVariableFunction(
      fromExpression: 'abs(sin(a) + cos(b))', withVariables: ['a', 'b']);
  print('```\n\nA rough plot of \$${tree.tex}\$:\n\n```');
  print('+${'-' * xs.length}+');
  for (var a in xs) {
    print('|${xs.map((b) {
      var value = tree({'a': a, 'b': b});
      if (value < 0.5) return ' ';
      if (value < 1) return ':';
      if (value < 1.5) return 'o';
      return '*';
    }).join()}|');
  }
  print('+${'-' * xs.length}+');
  print('```');
}
