import "dart:math";
import "package:function_tree/function_tree.dart";

void main() {
  final f = (num x) => 3 * exp(5 * x) + 2 * sin(5 * (3 * x + pi / 6)),
      expression = "3 * exp(5 * x) + 2 * sin(5 * (3 * x + pi / 6))",
      g = SingleVariableFunction(fromExpression: expression),
      stopwatch = Stopwatch(),
      column = (a, b) => a.toString().padRight(30) + b.toString(),
      calls = 1e5;

  print("\nThis test compares the evaluation speed of a native Dart");
  print("function to that of an equivalent function-tree instance...\n");
  print("The function under consideration is:\n");
  print("  $expression\n");
  print("Please wait...\n");

  stopwatch.start();
  for (var i = 0; i < 1e5; i++) {
    f(5);
  }

  stopwatch.stop();
  final dartFunction = stopwatch.elapsedMilliseconds;

  stopwatch
    ..reset()
    ..start();
  for (var i = 0; i < 1e5; i++) {
    g(5);
  }

  stopwatch.stop();
  final functionTree = stopwatch.elapsedMilliseconds;

  stopwatch
    ..reset()
    ..start();
  for (var i = 0; i < 1e5; i++) {
    SingleVariableFunction(fromExpression: expression)(5);
  }

  stopwatch.stop();
  final stringInterpretation = stopwatch.elapsedMilliseconds;

  print(column("${calls.toInt()} calls to...", "Time in µs"));
  print(column("-------------------", "----------"));
  print(column("Dart function", dartFunction));
  print(column("Function-tree", functionTree));
  print(column("String interpretation", stringInterpretation));
}
