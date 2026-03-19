import "package:function_tree/function_tree.dart";

void main() {
  final complexF = "x + i*x^2".toSingleVariableFunction();
  print("\nFunction: f(x) = x + i*x^2");
  print("Tree:\n${complexF.representation}\n");

  print("x\t\tReal\t\tImaginary\tMagnitude");
  print("-" * 60);
  for (var x = -2.0; x <= 2.0; x += 0.5) {
    final result = complexF.complexCall(Complex(x, 0));
    print("${x.toStringAsFixed(1)}\t\t"
        "${result.real.toStringAsFixed(3)}\t\t"
        "${result.imaginary.toStringAsFixed(3)}\t\t"
        "${result.magnitude.toStringAsFixed(3)}");
  }

  // Test complex function with complex input: f(z) = z^2
  print("\n");
  final complexG = "x^2".toSingleVariableFunction();
  print("Function: f(z) = z^2 with complex input");
  print("Evaluating at z = 1 + i:");
  final z = Complex(1, 1);
  final resultG = complexG.complexCall(z);
  print("Result: ${resultG.real} + ${resultG.imaginary}i");
  print("Expected: 0 + 2i (since (1+i)^2 = 1 + 2i - 1 = 2i)");

  // Test with imaginary unit
  print("\n");
  final complexH = "sqrt(-1)".toSingleVariableFunction();
  print("Function: f() = sqrt(-1)");
  final resultH = complexH.complexCall(Complex.zero);
  print("Result: ${resultH.real} + ${resultH.imaginary}i");
  print("Expected: 0 + 1i");

  // Test Euler's formula: e^(i*pi) = -1
  print("\n");
  final euler = "exp(i*pi)".toSingleVariableFunction();
  print("Function: f() = exp(i*pi) (Euler's formula)");
  final resultEuler = euler.complexCall(Complex.zero);
  print("Result: ${resultEuler.real.toStringAsFixed(10)} + "
      "${resultEuler.imaginary.toStringAsFixed(10)}i");
  print("Expected: -1 + 0i");
}
