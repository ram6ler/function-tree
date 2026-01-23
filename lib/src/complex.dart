import 'dart:math' as math;

class Complex {
  final double real;

  final double imaginary;

  const Complex(this.real, this.imaginary);

  static const zero = Complex(0, 0);

  static const one = Complex(1, 0);

  static const e = Complex(math.e, 0);

  static const i = Complex(0, 1);

  double get magnitude => math.sqrt(real * real + imaginary * imaginary);

  double get phase => math.atan2(imaginary, real);

  bool get isInfinite => real.isInfinite || imaginary.isInfinite;

  bool get isNaN => real.isNaN || imaginary.isNaN;

  bool get isReal => imaginary == 0;

  Complex operator +(Complex other) {
    return Complex(real + other.real, imaginary + other.imaginary);
  }

  Complex operator -(Complex other) =>
      Complex(real - other.real, imaginary - other.imaginary);

  Complex operator -() => Complex(-real, -imaginary);

  Complex operator *(Complex other) {
    return Complex(real * other.real - imaginary * other.imaginary,
        real * other.imaginary + imaginary * other.real);
  }

  Complex operator /(Complex other) {
    final denom = other.real * other.real + other.imaginary * other.imaginary;
    return Complex(
      (real * other.real + imaginary * other.imaginary) / denom,
      (imaginary * other.real - real * other.imaginary) / denom,
    );
  }

  Complex operator %(Complex other) {
    final div = this / other;
    final roundedReal = div.real.roundToDouble();
    final roundedImaginary = div.imaginary.roundToDouble();
    final roundedDiv = Complex(roundedReal, roundedImaginary);
    return this - (roundedDiv * other);
  }

  Complex ceil() {
    return Complex(real.ceilToDouble(), imaginary.ceilToDouble());
  }

  Complex floor() {
    return Complex(real.floorToDouble(), imaginary.floorToDouble());
  }

  Complex round() {
    return Complex(real.roundToDouble(), imaginary.roundToDouble());
  }

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
