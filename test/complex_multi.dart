import "package:function_tree/function_tree.dart";

void main() {
  // Test 1: Simple complex multi-variable function
  print("\nTest 1: f(x, y) = x + i*y");
  final f1 = "x + i*y".toMultiVariableFunction(["x", "y"]);
  print("Tree:\n${f1.representation}\n");

  final result1 = f1.complexCall({"x": Complex(2, 0), "y": Complex(3, 0)});
  print("f(2, 3) = ${result1.real} + ${result1.imaginary}i");
  print("Expected: 2 + 3i");

  // Test 2: Complex multiplication
  print("\n" + "-" * 60);
  print("\nTest 2: f(x, y) = x * y with complex inputs");
  final f2 = "x * y".toMultiVariableFunction(["x", "y"]);

  final result2 = f2.complexCall({"x": Complex(1, 1), "y": Complex(2, -1)});
  print("f(1+i, 2-i) = ${result2.real} + ${result2.imaginary}i");
  print("Expected: 3 + 1i (since (1+i)(2-i) = 2-i+2i+1 = 3+i)");

  // Test 3: Complex polynomial
  print("\n" + "-" * 60);
  print("\nTest 3: f(x, y) = x^2 + y^2");
  final f3 = "x^2 + y^2".toMultiVariableFunction(["x", "y"]);

  final result3 = f3.complexCall({"x": Complex(1, 1), "y": Complex(1, -1)});
  print("f(1+i, 1-i) = ${result3.real} + ${result3.imaginary}i");
  print("Expected: 0 + 0i (since (1+i)^2 + (1-i)^2 = 2i + (-2i) = 0)");

  // Test 4: Complex function with trig
  print("\n" + "-" * 60);
  print("\nTest 4: f(x, y) = sin(x) + cos(y)");
  final f4 = "sin(x) + cos(y)".toMultiVariableFunction(["x", "y"]);

  final result4 = f4.complexCall({
    "x": Complex(0, 1), // i
    "y": Complex(0, 1) // i
  });
  print("f(i, i) = ${result4.real} + ${result4.imaginary}i");
  print("sin(i) ≈ 0 + 1.175i, cos(i) ≈ 1.543 + 0i");

  // Test 5: Complex ratio
  print("\n" + "-" * 60);
  print("\nTest 5: f(x, y) = x / y");
  final f5 = "x / y".toMultiVariableFunction(["x", "y"]);

  final result5 = f5.complexCall({"x": Complex(1, 1), "y": Complex(1, -1)});
  print("f(1+i, 1-i) = ${result5.real} + ${result5.imaginary}i");
  print("Expected: 0 + 1i (since (1+i)/(1-i) = i)");

  // Test 6: Complex power function
  print("\n" + "-" * 60);
  print("\nTest 6: f(x, y) = x^y");
  final f6 = "x^y".toMultiVariableFunction(["x", "y"]);

  final result6 = f6.complexCall({
    "x": Complex(0, 1), // i
    "y": Complex(2, 0) // 2
  });
  print("f(i, 2) = ${result6.real} + ${result6.imaginary}i");
  print("Expected: -1 + 0i (since i^2 = -1)");

  // Test 7: Mixed operations
  print("\n" + "-" * 60);
  print("\nTest 7: f(x, y) = sqrt(x) + exp(y)");
  final f7 = "sqrt(x) + exp(y)".toMultiVariableFunction(["x", "y"]);

  final result7 = f7.complexCall({
    "x": Complex(-1, 0), // -1
    "y": Complex(0, 0) // 0
  });
  print("f(-1, 0) = ${result7.real} + ${result7.imaginary}i");
  print("Expected: 1 + 1i (since sqrt(-1) = i and exp(0) = 1)");

  // Test 8: Complex abs (magnitude)
  print("\n" + "-" * 60);
  print("\nTest 8: f(x, y) = abs(x + i*y)");
  final f8 = "abs(x + i*y)".toMultiVariableFunction(["x", "y"]);

  final result8 = f8.complexCall({"x": Complex(3, 0), "y": Complex(4, 0)});
  print("f(3, 4) = ${result8.real} + ${result8.imaginary}i");
  print("Expected: 5 + 0i (since |3 + 4i| = 5)");

  print("\n" + "=" * 60);
  print("All complex multi-variable tests completed!");
  print("=" * 60);
}
