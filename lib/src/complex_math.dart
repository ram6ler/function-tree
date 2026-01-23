import 'complex.dart';
import 'dart:math' as math;

class ComplexMath {
  static Complex logBase(Complex base, Complex x) {
    return log(x) / log(base);
  }

  static Complex nrt(Complex n, Complex x) {
    return pow(x, Complex(1, 0) / n);
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
    return sin(c) / cos(c);
  }

  static Complex acos(Complex c) {
    final i = Complex(0, 1);
    // acos(z) = π/2 - asin(z) is more numerically stable
    // Alternatively: acos(z) = -i * log(z + i*sqrt(1 - z²))
    final sqrtPart = sqrt(Complex.one - c * c);
    return -i * log(c + i * sqrtPart);
  }

  static Complex asin(Complex c) {
    final i = Complex(0, 1);
    return -i * log(i * c + sqrt(Complex.one - c * c));
  }

  static Complex atan(Complex c) {
    final i = Complex(0, 1);
    return (i / Complex(2, 0)) * log((i + c) / (i - c));
  }

  static Complex exp(Complex c) {
    final expReal = math.exp(c.real);
    return Complex(
        expReal * math.cos(c.imaginary), expReal * math.sin(c.imaginary));
  }

  static Complex cosh(Complex c) {
    return (pow(Complex.e, c) + pow(Complex.e, -c)) / Complex(2, 0);
  }

  static Complex sinh(Complex c) {
    return (pow(Complex.e, c) - pow(Complex.e, -c)) / Complex(2, 0);
  }

  static Complex tanh(Complex c) {
    return sinh(c) / cosh(c);
  }

  static Complex cot(Complex c) {
    return Complex.one / tan(c);
  }

  static Complex coth(Complex c) {
    return cosh(c) / sinh(c);
  }

  static Complex csc(Complex c) {
    return Complex.one / sin(c);
  }

  static Complex csch(Complex c) {
    return Complex.one / sinh(c);
  }

  static Complex sec(Complex c) {
    return Complex.one / cos(c);
  }

  static Complex sech(Complex c) {
    return Complex(2, 0) / (pow(Complex.e, c) + pow(Complex.e, -c));
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
      return Complex(math.pi, 0) /
          (sin(Complex(math.pi, 0) * z) * gamma(Complex.one - z));
    }

    z = z - Complex.one;
    Complex x = Complex(coefficients[0], 0);
    for (int i = 1; i < g + 2; i++) {
      x = x + Complex(coefficients[i], 0) / (z + Complex(i.toDouble(), 0));
    }

    final t = z + Complex(g + 0.5, 0);
    final sqrtTwoPi = Complex(math.sqrt(2 * math.pi), 0);
    return sqrtTwoPi * pow(t, z + Complex(0.5, 0)) * exp(-t) * x;
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
    return gamma(c + Complex.one);
  }

  static Complex abs(Complex c) {
    return Complex(c.magnitude, 0);
  }

  static Complex ceil(Complex c) {
    return c.ceil();
  }

  static Complex floor(Complex c) {
    return c.floor();
  }

  static Complex round(Complex c) {
    return c.round();
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
