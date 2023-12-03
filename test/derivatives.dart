import "dart:math" as math;
import "package:function_tree/function_tree.dart";

void main() {
  const dx = 1e-6;
  num numeric(num Function(num) f, num x) => (f(x + dx) - f(x)) / dx;

  String columns(List<Object> xs) {
    const digits = 8, width = 15;

    if (xs.first is double) {
      return [
        for (final x in xs) (x as double).toStringAsFixed(digits).padLeft(width)
      ].join("");
    }
    return [for (final x in xs) x.toString().padLeft(width)].join("");
  }

  final tests = {
    "2 * x ^ 3": (0, 5),
    "3 ^ (x / 2 + 0.1)": (0, 5),
    "(2 * (x + 0.1)) ^ (1 / (x ^ 2))": (1, 4),
    "exp(x / 5)": (0, 5),
    "log(2 * x + 3)": (1, 10),
    "3 * sin(2 * (x - pi))": (-math.pi, math.pi),
    "5 * cos(x / (x + 1)) ^ 2": (-math.pi, math.pi),
    "2 * acos(2 * x) + pi / 6": (-0.45, 0.45),
    "2 * asin(3 * x ^ 2) + pi / 6": (-0.45, 0.45),
    "2 * atan(3 * x ^ 2) + pi / 6": (-10, 10),
    "cot(x^2)": (math.pi / 6, math.pi / 2),
    "csc(x^2)": (math.pi / 6, math.pi / 2),
    "sec(x^2)": (-math.pi / 3, math.pi / 3),
    "cosh(3 * x + 1)": (-math.pi / 2, math.pi / 2),
    "sinh(3 * x + 1)": (-math.pi / 2, math.pi / 2),
    "tanh(3 * x + 1)": (-math.pi / 2, math.pi / 2),
    "coth(3 * x + 1)": (0.0, math.pi / 4),
    "sech(3 * x + 1)": (-math.pi / 4, math.pi / 2),
    "csch(3 * x + 1)": (0.0, math.pi),
  };

  for (final MapEntry(:key, :value) in tests.entries) {
    final (start, end) = value;
    print("\nExpression: $key:\n");
    final f = key.toSingleVariableFunction(), d = f.derivative("x");
    print("Derivative Tree:\n\n${d.representation}\n");
    print("Sample:\n");
    print(columns(["x", "f(x)", "num f'(x)", "f'(x)", "e"]));
    for (var i = 0; i <= 10; i++) {
      final x = start + (end - start) * i / 10,
          numericEstimate = numeric(f, x),
          treeResult = d(x),
          error = (numericEstimate - treeResult).abs();
      print(columns([x, f(x), numericEstimate, treeResult, error]));
    }
    print("-" * 80);
  }
}
