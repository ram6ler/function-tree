import 'package:function_tree/function_tree.dart';

void main() {
  for (final expression in [
    '-3+6',
    '+3-6',
    '-sin(2*pi)',
    '-(-3+6)',
    '-cos(2*pi)',
    '-3+3*3+3-3',
    '-(+3)'
  ]) {
    print('$expression = ');

    print('   : ${expression.interpret()}');
  }
}
