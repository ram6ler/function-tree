import "package:function_tree/function_tree.dart";

void main() {
  final error = 1e-9;
  bool checkError(Complex a, Complex b) => (a - b).magnitude < error;

  final testCases = <String, Complex>{
    // Basic imaginary unit
    "i": Complex(0, 1),
    "2*i": Complex(0, 2),
    "-i": Complex(0, -1),
    "3*i": Complex(0, 3),

    // Simple complex numbers
    "1+i": Complex(1, 1),
    "2-3*i": Complex(2, -3),
    "3+4*i": Complex(3, 4),
    "5-2*i": Complex(5, -2),

    // Complex arithmetic - addition/subtraction
    "(1+i)+(2-i)": Complex(3, 0),
    "(1+i)-(2-i)": Complex(-1, 2),
    "(3+2*i)+(1+4*i)": Complex(4, 6),

    // Complex arithmetic - multiplication
    "i*i": Complex(-1, 0),
    "(1+i)*(1-i)": Complex(2, 0),
    "(2+3*i)*(4-5*i)": Complex(23, 2),

    // Complex arithmetic - division
    "(2+4*i)/(1+i)": Complex(3, 1),
    "1/i": Complex(0, -1),
    "(3+4*i)/(1-2*i)": Complex(-1, 2),

    // Powers of i
    "i^2": Complex(-1, 0),
    "i^3": Complex(0, -1),
    "i^4": Complex(1, 0),

    // Complex powers
    "(1+i)^2": Complex(0, 2),
    "(2+i)^2": Complex(3, 4),

    // Complex constants
    "2+i*3": Complex(2, 3),
    "i+1": Complex(1, 1),

    // sqrt function
    "sqrt(-1)": Complex(0, 1),
    "sqrt(-4)": Complex(0, 2),
    "sqrt(-9)": Complex(0, 3),
    "sqrt(i)": Complex(0.7071067811865476, 0.7071067811865475),

    // exp function
    "exp(i*pi)": Complex(-1, 0), // Euler's formula

    // sin function - real argument
    "sin(0)": Complex(0, 0),
    "sin(pi/2)": Complex(1, 0),

    // sin function - complex argument
    "sin(i)": Complex(0, 1.1752011936438014),
    "sin(1+i)": Complex(1.2984575814159773, 0.6349639147847361),

    // cos function - real argument
    "cos(0)": Complex(1, 0),
    "cos(pi)": Complex(-1, 0),

    // cos function - complex argument
    "cos(i)": Complex(1.5430806348152437, 0),
    "cos(1+i)": Complex(0.8337300251311491, -0.9888977057628651),

    // tan function
    "tan(0)": Complex(0, 0),
    "tan(pi/4)": Complex(0.9999999999999999, 0),

    // tan function - complex argument
    "tan(i)": Complex(0, 0.7615941559557649),
    "tan(1+i)": Complex(0.27175258531951174, 1.0839233273386946),

    // sinh function
    "sinh(0)": Complex(0, 0),

    // sinh function - complex argument
    "sinh(i)": Complex(0, 0.8414709848078965),
    "sinh(1+i)": Complex(0.6349639147847361, 1.2984575814159773),

    // cosh function
    "cosh(0)": Complex(1, 0),

    // cosh function - complex argument
    "cosh(i)": Complex(0.5403023058681398, 0),
    "cosh(1+i)": Complex(0.8337300251311491, 0.9888977057628651),

    // tanh function
    "tanh(0)": Complex(0, 0),

    // tanh function - complex argument
    "tanh(i)": Complex(0, 1.557407724654902),
    "tanh(1+i)": Complex(1.0839233273386946, 0.27175258531951174),

    // asin function
    "asin(0)": Complex(0, 0),

    // asin function - complex argument
    "asin(i)": Complex(0, 0.881373587019543),
    "asin(2)": Complex(1.5707963267948966, -1.3169578969248166),

    // acos function
    "acos(1)": Complex(0, 0),

    // acos function - complex argument
    "acos(i)": Complex(1.5707963267948966, -0.881373587019543),
    "acos(2)": Complex(0, 1.3169578969248166),

    // atan function
    "atan(0)": Complex(0, 0),

    // atan function - complex argument
    "atan(1+i)": Complex(1.0172219678978514, 0.4023594781085251),

    // abs (magnitude) function
    "abs(3+4*i)": Complex(5, 0),
    "abs(1+i)": Complex(1.4142135623730951, 0),

    // ceil, floor, round
    "ceil(1.2+3.7*i)": Complex(2, 4),
    "floor(1.8+3.2*i)": Complex(1, 3),
    "round(1.4+2.6*i)": Complex(1, 3),

    // Two-parameter functions
    "pow(2, 3)": Complex(8, 0),
    "pow(i, 2)": Complex(-1, 0),
    "log(2, 8)": Complex(3, 0),
    "nrt(2, 4)": Complex(2, 0),

    // Trigonometric reciprocals with real args
    "sec(0)": Complex(1, 0),
    "csc(pi/2)": Complex(1, 0),
    "cot(pi/4)": Complex(1, 0),

    // Trigonometric reciprocals with complex args
    "sec(i)": Complex(0.6480542736638855, 0),
    "csc(i)": Complex(0, -0.8509181282393216),
    "cot(i)": Complex(0, -1.3130352854993315),

    // Hyperbolic reciprocals
    "sech(0)": Complex(1, 0),
    "coth(1)": Complex(1.3130352854993315, 0),

    // Hyperbolic reciprocals with complex args
    "sech(i)": Complex(1.8508157176809255, 0),
    "csch(i)": Complex(0, -1.1883951057781212),
    "coth(1+i)": Complex(0.8680141428959249, -0.21762156185440265),

    // ln and log
    "ln(e)": Complex(1, 0),
    "log(e)": Complex(1, 0),

    // Complex logarithms
    "ln(i)": Complex(0, 1.5707963267948966),
    "ln(-1)": Complex(0, 3.141592653589793),
    "ln(1+i)": Complex(0.34657359027997264, 0.7853981633974483),

    // Factorial with small integers
    "fact(0)": Complex(1, 0),
    "fact(1)": Complex(1, 0),
    "fact(3)": Complex(6, 0),
    "fact(5)": Complex(120, 0),

    // More complex powers
    "(-1)^(1/2)": Complex(0, 1),
    "(1+i)^3": Complex(-2, 2),
    "e^(i*pi/2)": Complex(0, 1),

    // Combined operations
    "(1+i)*(2+i)-(3+i)": Complex(-2, 2),
    "sin(i)*cos(i)": Complex(0, 1.8134302039235093),
    "exp(i*pi/4)": Complex(0.7071067811865476, 0.7071067811865475),

    // More division cases
    "i/(1+i)": Complex(0.5, 0.5),
    "(3-4*i)/(5+12*i)": Complex(-0.1952662721893491, -0.33136094674556216),

    // Complex with real operations
    "2*(1+i)": Complex(2, 2),
    "(1+i)/2": Complex(0.5, 0.5),
    "3+(2+i)": Complex(5, 1),

    // Nested functions
    "sqrt(sqrt(-1))": Complex(0.7071067811865476, 0.7071067811865475),
    "sin(cos(i))": Complex(0.9996159447946292, 0),
    "exp(ln(2+3*i))": Complex(2, 3),

    // Complex modulo
    "(5+2*i)%(2+i)": Complex(1, 0),
    "(7+3*i)%(3+i)": Complex(1, 1),
    "(10+5*i)%(3+2*i)": Complex(1, -1),
    "(8+6*i)%(2+3*i)": Complex(-1, -1),
    "(15+10*i)%(4+3*i)": Complex(-1, -2),
    "(11+7*i)%(5+2*i)": Complex(1, 3),
    "(9+4*i)%(2+2*i)": Complex(1, 0),
    "(6+8*i)%(3+i)": Complex(-1, -1),
    "(12+5*i)%(4+i)": Complex(0, 2),
    "(13+13*i)%(5+5*i)": Complex(-2, -2),

    // More trig with specific values
    "sin(pi/6)": Complex(0.49999999999999994, 0),
    "cos(pi/3)": Complex(0.5000000000000001, 0),
    "tan(pi/3)": Complex(1.7320508075688767, 0),

    // Complex exponentials
    "exp(2*i)": Complex(-0.4161468365471424, 0.9092974268256817),
    "exp(1+i)": Complex(1.4686939399158851, 2.2873552871788423),

    // Hyperbolic with complex args
    "sinh(2+i)": Complex(1.9596010414216058, 3.165778513216168),
    "cosh(2+i)": Complex(2.0327230070196656, 3.0518977991517997),
    "tanh(2+i)": Complex(1.0147936161466338, 0.03381282607989681),

    // Mixed real and imaginary
    "(3+0*i)+(0+4*i)": Complex(3, 4),
    "5*i*i": Complex(-5, 0),
    "(2*i)^2": Complex(-4, 0),

    // Small complex numbers
    "sqrt(0.01+0.01*i)": Complex(0.109868411346781, 0.045508986056222736),
    "(0.1+0.1*i)^2": Complex(0, 0.02),

    // Large complex numbers
    "(10+10*i)*(10-10*i)": Complex(200, 0),
    "sqrt(100+100*i)": Complex(10.986841134678098, 4.550898605622274),

    // Negative powers
    "(2+i)^(-1)": Complex(0.4, -0.2),
    "i^(-1)": Complex(0, -1),

    // Complex with pi and e
    "e^(i*pi/6)+i": Complex(0.8660254037844387, 1.5),
    "pi*i": Complex(0, 3.141592653589793),

    // Multiple operations chained
    "((1+i)^2)*(2-i)": Complex(2, 4),
    "sqrt((3+4*i)*(3-4*i))": Complex(5, 0),
    "abs(abs(3+4*i))": Complex(5, 0),
  };

  var passCount = 0;
  var failCount = 0;

  testCases.forEach((expression, expected) {
    final f = expression.toSingleVariableFunction(),
        obtained = f.complexCall({}),
        okay = checkError(obtained, expected);

    print("Expression: $expression");
    print("Result:     ${obtained.real} + ${obtained.imaginary}i");
    print("Expected:   ${expected.real} + ${expected.imaginary}i");
    print(okay ? "✓ Pass" : "✗ Fail");
    print("-" * 50);

    if (okay) {
      passCount++;
    } else {
      failCount++;
    }
  });

  print("\n${"=" * 50}");
  print("Test Summary: $passCount passed, $failCount failed");
  print("=" * 50);
}
