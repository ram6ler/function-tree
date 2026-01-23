import 'complex.dart';
import 'dart:math' as math;

class ComplexMath {
  static Complex add(Complex a, Complex b) {
    return Complex(a.real + b.real, a.imaginary + b.imaginary);
  }

  static Complex subtract(Complex a, Complex b) {
    return Complex(a.real - b.real, a.imaginary - b.imaginary);
  }

  static Complex negate(Complex a) {
    return Complex(-a.real, -a.imaginary);
  }

  static Complex multiply(Complex a, Complex b) {
    return Complex(a.real * b.real - a.imaginary * b.imaginary,
        a.real * b.imaginary + a.imaginary * b.real);
  }

  static Complex divide(Complex a, Complex b) {
    final denom = b.real * b.real + b.imaginary * b.imaginary;
    return Complex(
      (a.real * b.real + a.imaginary * b.imaginary) / denom,
      (a.imaginary * b.real - a.real * b.imaginary) / denom,
    );
  }

  static Complex modulo(Complex a, Complex b) {
    final div = divide(a, b);
    final roundedReal = div.real.roundToDouble();
    final roundedImaginary = div.imaginary.roundToDouble();
    final roundedDiv = Complex(roundedReal, roundedImaginary);
    return subtract(a, multiply(roundedDiv, b));
  }

  static Complex ceil(Complex c) {
    return Complex(c.real.ceilToDouble(), c.imaginary.ceilToDouble());
  }

  static Complex floor(Complex c) {
    return Complex(c.real.floorToDouble(), c.imaginary.floorToDouble());
  }

  static Complex round(Complex c) {
    return Complex(c.real.roundToDouble(), c.imaginary.roundToDouble());
  }

  static Complex logBase(Complex base, Complex x) {
    return divide(log(x), log(base));
  }

  static Complex nrt(Complex n, Complex x) {
    return pow(x, divide(Complex(1, 0), n));
  }

  static Complex sqrt(Complex c) {
    final r = math.sqrt(c.magnitude);
    final theta = c.phase / 2;
    return Complex(r * math.cos(theta), r * math.sin(theta));
  }

  static Complex pow(Complex base, Complex exponent) {
    // Handle special case: 0^n = 0 for n > 0
    if (base.magnitude == 0) {
      if (exponent.real > 0 ||
          (exponent.real == 0 && exponent.imaginary != 0)) {
        return Complex.zero;
      }
      // 0^0 or 0^negative is undefined, return NaN
      return Complex(double.nan, double.nan);
    }

    final r = math.pow(base.magnitude, exponent.real) *
        math.exp(-exponent.imaginary * base.phase);
    final theta = exponent.real * base.phase +
        exponent.imaginary * math.log(base.magnitude);
    return Complex(r * math.cos(theta), r * math.sin(theta));
  }

  static Complex log(Complex c) {
    return Complex(math.log(c.magnitude), c.phase);
  }

  static Complex cos(Complex c) {
    return Complex(math.cos(c.real) * _cosh(c.imaginary),
        -math.sin(c.real) * _sinh(c.imaginary));
  }

  static Complex sin(Complex c) {
    return Complex(math.sin(c.real) * _cosh(c.imaginary),
        math.cos(c.real) * _sinh(c.imaginary));
  }

  static Complex tan(Complex c) {
    return divide(sin(c), cos(c));
  }

  static Complex acos(Complex c) {
    final i = Complex(0, 1);
    // acos(z) = π/2 - asin(z) is more numerically stable
    // Alternatively: acos(z) = -i * log(z + i*sqrt(1 - z²))
    final sqrtPart = sqrt(subtract(Complex.one, multiply(c, c)));
    return multiply(negate(i), log(add(c, multiply(i, sqrtPart))));
  }

  static Complex asin(Complex c) {
    final i = Complex(0, 1);
    return multiply(negate(i),
        log(add(multiply(i, c), sqrt(subtract(Complex.one, multiply(c, c))))));
  }

  static Complex atan(Complex c) {
    final i = Complex(0, 1);
    return multiply(
        divide(i, Complex(2, 0)), log(divide(add(i, c), subtract(i, c))));
  }

  static Complex exp(Complex c) {
    final expReal = math.exp(c.real);
    return Complex(
        expReal * math.cos(c.imaginary), expReal * math.sin(c.imaginary));
  }

  static Complex cosh(Complex c) {
    return divide(
        add(pow(Complex.e, c), pow(Complex.e, negate(c))), Complex(2, 0));
  }

  static Complex sinh(Complex c) {
    return divide(
        subtract(pow(Complex.e, c), pow(Complex.e, negate(c))), Complex(2, 0));
  }

  static Complex tanh(Complex c) {
    return divide(sinh(c), cosh(c));
  }

  static Complex cot(Complex c) {
    return divide(Complex.one, tan(c));
  }

  static Complex coth(Complex c) {
    return divide(cosh(c), sinh(c));
  }

  static Complex csc(Complex c) {
    return divide(Complex.one, sin(c));
  }

  static Complex csch(Complex c) {
    return divide(Complex.one, sinh(c));
  }

  static Complex sec(Complex c) {
    return Complex.one / cos(c);
  }

  static Complex sech(Complex c) {
    return divide(
        Complex(2, 0), add(pow(Complex.e, c), pow(Complex.e, negate(c))));
  }

  // Helper methods for real hyperbolic functions
  static double _sinh(double x) {
    return (math.exp(x) - math.exp(-x)) / 2;
  }

  static double _cosh(double x) {
    return (math.exp(x) + math.exp(-x)) / 2;
  }

  /// Gamma function for complex numbers using Lanczos approximation
  static Complex gamma(Complex z) {
    // Lanczos approximation coefficients
    const g = 7;
    const coefficients = [
      0.99999999999980993,
      676.5203681218851,
      -1259.1392167224028,
      771.32342877765313,
      -176.61502916214059,
      12.507343278686905,
      -0.13857109526572012,
      9.9843695780195716e-6,
      1.5056327351493116e-7
    ];

    // Use reflection formula for Re(z) < 0.5
    if (z.real < 0.5) {
      return divide(
          Complex.pi,
          multiply(
              sin(multiply(Complex.pi, z)), gamma(subtract(Complex.one, z))));
    }

    z = subtract(z, Complex.one);
    Complex x = Complex(coefficients[0], 0);
    for (int i = 1; i < g + 2; i++) {
      x = add(
          x,
          divide(
              Complex(coefficients[i], 0), add(z, Complex(i.toDouble(), 0))));
    }

    final t = add(z, Complex(g + 0.5, 0));
    final sqrtTwoPi = Complex(math.sqrt(2 * math.pi), 0);
    return multiply(
        multiply(multiply(sqrtTwoPi, pow(t, add(z, Complex(0.5, 0)))),
            exp(negate(t))),
        x);
  }

  /// Factorial function for complex numbers
  /// For non-negative integers, returns n!
  /// For other values, uses Gamma(z+1)
  static Complex fact(Complex c) {
    // For real non-negative integers, use exact calculation
    if (c.imaginary == 0 && c.real >= 0 && c.real == c.real.toInt()) {
      final n = c.real.toInt();
      double result = 1.0;
      for (int i = 2; i <= n; i++) {
        result *= i;
      }
      return Complex(result, 0);
    }
    // For other values, use gamma(z+1)
    return gamma(add(c, Complex.one));
  }

  static Complex abs(Complex c) {
    return Complex(c.magnitude, 0);
  }

  /// A mapping of string representations to two-parameter functions.
  static const twoParameterFunctionMap =
      <String, Complex Function(Complex, Complex)>{
    "log": ComplexMath.logBase,
    "nrt": ComplexMath.nrt,
    "pow": ComplexMath.pow
  };

  /// A mapping of string representations to one-parameter functions.
  static const oneParameterFunctionMap = <String, Complex Function(Complex)>{
    "abs": ComplexMath.abs,
    "acos": ComplexMath.acos,
    "asin": ComplexMath.asin,
    "atan": ComplexMath.atan,
    "ceil": ComplexMath.ceil,
    "cos": ComplexMath.cos,
    "cosh": ComplexMath.cosh,
    "cot": ComplexMath.cot,
    "coth": ComplexMath.coth,
    "csc": ComplexMath.csc,
    "csch": ComplexMath.csch,
    "exp": ComplexMath.exp,
    "fact": ComplexMath.fact,
    "floor": ComplexMath.floor,
    "ln": ComplexMath.log,
    "log": ComplexMath.log,
    "round": ComplexMath.round,
    "sec": ComplexMath.sec,
    "sech": ComplexMath.sech,
    "sin": ComplexMath.sin,
    "sinh": ComplexMath.sinh,
    "sqrt": ComplexMath.sqrt,
    "tan": ComplexMath.tan,
    "tanh": ComplexMath.tanh
  };
}
