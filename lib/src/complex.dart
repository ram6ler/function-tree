import 'dart:math' as math;
import 'complex_math.dart';

class Complex {
  final double real;

  final double imaginary;

  const Complex(this.real, this.imaginary);

  Complex.polar(double magnitude, double phase)
      : real = magnitude * math.cos(phase),
        imaginary = magnitude * math.sin(phase);

  static const zero = Complex(0, 0);

  static const one = Complex(1, 0);

  static const e = Complex(math.e, 0);

  static const i = Complex(0, 1);

  static const pi = Complex(math.pi, 0);

  double get magnitude => math.sqrt(real * real + imaginary * imaginary);

  double get phase => math.atan2(imaginary, real);

  bool get isInfinite => real.isInfinite || imaginary.isInfinite;

  bool get isNaN => real.isNaN || imaginary.isNaN;

  bool get isReal => imaginary == 0;

  Complex operator +(Complex other) => ComplexMath.add(this, other);

  Complex operator -(Complex other) => ComplexMath.subtract(this, other);

  Complex operator -() => ComplexMath.negate(this);

  Complex operator *(Complex other) => ComplexMath.multiply(this, other);

  Complex operator /(Complex other) => ComplexMath.divide(this, other);

  Complex operator %(Complex other) => ComplexMath.modulo(this, other);

  double operator [](int index) {
    if (index == 0) return real;
    if (index == 1) return imaginary;
    throw RangeError.index(index, this, 'Index out of range: $index');
  }

  Complex ceil() => ComplexMath.ceil(this);

  Complex floor() => ComplexMath.floor(this);

  Complex round() => ComplexMath.round(this);

  @override
  bool operator ==(Object other) {
    if (other is Complex) {
      return real == other.real && imaginary == other.imaginary;
    }
    return false;
  }

  @override
  int get hashCode => Object.hash(real, imaginary);
}

extension NumToComplex on num {
  Complex toComplex() {
    return Complex(toDouble(), 0);
  }
}
