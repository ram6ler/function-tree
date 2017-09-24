import 'package:function_tree/function_tree.dart';

void main() {
  var f = new FunctionOfX("2 * x^2 + 1");
  for (num x = -5; x <= 5; x += 0.5) {
    print("|${" " * f(x).round()}+");
  }
}
