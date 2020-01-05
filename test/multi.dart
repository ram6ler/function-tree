import 'package:function_tree/function_tree.dart';

void main() {
  final f = 'sqrt(x^2+y^2+x*y)/1.5'.toMultiVariableFunction(['x', 'y']),
      width = 30,
      from = -3,
      to = 3,
      by = (to - from) / width,
      ch = (num result) => result > 3
          ? '█'
          : (result > 2.5
              ? '▓'
              : (result > 2
                  ? '▒'
                  : (result > 1.5 ? '░' : result > 0.5 ? '·' : ' ')));
  print(List<String>.generate(
      width,
      (y) => List<String>.generate(
              width, (x) => ch(f({'x': from + x * by, 'y': from + y * by})))
          .join()).join('\n'));
}
