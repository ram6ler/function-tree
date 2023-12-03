import "package:function_tree/function_tree.dart";

void main() {
  final error = 1e-9;
  const {
    "-3+6": 3.0,
    "+3-6": -3.0,
    "-sin(2*pi)": 0.0,
    "-(-3+6)": -3.0,
    "-cos(2*pi)": -1.0,
    "-3+3*3+3-3": 6.0,
    "-(+3)": -3.0,
    "1*10^50": 1e+50,
    "5*-1": -5.0,
    "sqrt2": 1.4142135623730951,
    "-csc(pi/6)": -2.0,
    "1/-sin(pi/6)+1*-5": -7.0,
    "1/-sin(-13*-pi/6)+1/-0.2": -7.0,
    "2^+3": 8.0,
    "5%+2": 1.0,
    "+++(1 + 1)": 2,
    "8/16": 0.5,
    "3 -(-1)": 4,
    "2 + -2": 0,
    "10- 2- -5": 13,
    "(((10)))": 10,
    "3 * 5": 15,
    "-7 * -(6 / 3)": 14,
    "-11 - 77 - -18 + 39 + -26 + -25 / 4 - -9": -54.25,
    "-(-25) + (26 - 29 * -(32)) / (-62 * ((((5 + -73)))) / -17)":
        21.153225806451612,
    "2+(-2)": 0,
    "fact(5)": 120,
    "2 * 5!": 240,
  }.forEach((expression, expected) {
    final _ = 0,
        f = expression.toSingleVariableFunction(),
        obtained = f(_),
        okay = (obtained - expected).abs() < error;

    print("Received:  $expression");
    print("toString:  $f");
    print("Evaluated: $obtained");
    print("Expected:  $expected");
    print("Tree:\n");
    print("${f.tree.representation()}\n");
    print(okay ? "Okay!" : "Fail...");
    print("-" * 50);
  });

  print("3 * 5!".interpret());
  print("0!".interpret());
}
