import 'package:function_tree/function_tree.dart';

void main() {
  final error = 1e-9;
  const {
    '-3+6': 3.0,
    '+3-6': -3.0,
    '-sin(2*pi)': 0.0,
    '-(-3+6)': -3.0,
    '-cos(2*pi)': -1.0,
    '-3+3*3+3-3': 6.0,
    '-(+3)': -3.0,
    '1*10^50': 1e+50,
    '5*-1': -5.0,
    '-csc(pi/6)': -2.0,
    '1/-sin(pi/6)+1*-5': -7.0,
    '1/-sin(-13*-pi/6)+1/-0.2': -7.0,
    '2^+3': 8.0,
    '5%+2': 1.0,
  }.forEach((expression, expected) {
    final obtained = expression.interpret(),
        okay = (obtained - expected).abs() < error;
    print('$expression = ${obtained}');
    if (okay) {
      print('   ... okay!');
    } else {
      print('   ... should be: $expected!');
    }
  });
}
