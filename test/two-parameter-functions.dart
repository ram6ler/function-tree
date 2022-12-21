import 'package:function_tree/function_tree.dart';

void main() {
  final f = 'log(3, x)'.toSingleVariableFunction();
  print(f(9));
  print(f.tex);

  final g = 'pow(x, y)'.toMultiVariableFunction(['x', 'y']);
  print(g({'x': 2, 'y': 3}));
  print(g.tex);
  print(g.toString());

  final h = 'nrt(3, 27)'.interpret();
  print(h);

  final i = 'nrt(3, -3)'.interpret();
  print(i);
}
