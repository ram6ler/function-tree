import 'package:function_tree/function_tree.dart';

void main() {
  var f = FunctionOfX("abs(2 * x^2 -15 )");
  for (num x = -5; x <= 5; x += 0.5) {
    print("|${" " * f(x).round()}+");
  }
}
