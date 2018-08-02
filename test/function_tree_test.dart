import 'dart:math';
import 'package:function_tree/function_tree.dart';

void main() {
  print("\nLet's compare the evaluation speed of a native Dart function to");
  print("that of an equivalent function tree instance...\n");

  num Function(num) f =
      (num x) => 3 * exp(5 * x) + 2 * sin(5 * (3 * x + pi / 6));

  var string = "3 * exp(5 * x) + 2 * sin(5 * (3 * x + pi / 6))",
      g = FunctionOfX(string);

  print("The function under consideration is:\n   $string\n");

  var stopwatch = Stopwatch();

  stopwatch.start();
  for (int i = 0; i < 1e5; i++) f(5);
  stopwatch.stop();
  print(
      "100 000 calls to native function f: ${stopwatch.elapsedMilliseconds} µs.\n");

  stopwatch
    ..reset()
    ..start();
  for (int i = 0; i < 1e5; i++) g(5);
  stopwatch.stop();
  print(
      "100 000 calls to function tree g, built from the string: ${stopwatch.elapsedMilliseconds} µs.\n");

  print("Of course, tree construction itself takes time...\n");

  stopwatch
    ..reset()
    ..start();
  for (int i = 0; i < 1e5; i++) FunctionOfX(string)(5);
  stopwatch.stop();
  print(
      "100 000 calls to construct and evaluate tree (equivalent to parsing the string each call): ${stopwatch.elapsedMilliseconds} µs.\n");
}
