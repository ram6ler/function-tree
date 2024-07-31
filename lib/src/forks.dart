import "dart:math";
import "base.dart" show Node;
import "defs.dart" as defs;
import "constant_check.dart" show isConstant;
import "leaves.dart" show ConstantLeaf;
import "branches.dart" show FunctionBranch;

/// General base class for nodes with two child nodes.
abstract class Fork extends Node {
  /// Fork operand.
  final Node left, right;

  /// Fork label in tree representation.
  final String label;

  /// TeX expression generator.
  final String Function(Node, Node) generateTeX;

  /// String expression generator.
  final String Function(Node, Node) generateString;

  /// Operator definition.
  final num Function(num, num) definition;

  Fork({
    required this.left,
    required this.right,
    required this.label,
    required this.generateTeX,
    required this.generateString,
    required this.definition,
  });

  @override
  num call(Map<String, num> variables) =>
      definition(left(variables), right(variables));

  @override
  String toTeX() => generateTeX(left, right);

  @override
  String representation([int indent = 0]) {
    final tab = " " * indent;
    return "$label:\n$tab  ${left.representation(indent + 2)}"
        "\n$tab  ${right.representation(indent + 2)}";
  }

  @override
  String toString() => generateString(left, right);
}

/// A node representing the sum of two expressions.
class SumFork extends Fork {
  SumFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Sum",
          generateTeX: (left, right) => "${left.toTeX()} + ${right.toTeX()}",
          generateString: (left, right) => "$left + $right",
          definition: (a, b) => a + b,
        );

  @override
  Node derivative(String variableName) => SumFork(
      left.derivative(variableName),
      right.derivative(
        variableName,
      ));
}

/// A node representing the difference between two expressions.
class DifferenceFork extends Fork {
  DifferenceFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Difference",
          generateTeX: (left, right) => "${left.toTeX()} - ${right.toTeX()}",
          generateString: (left, right) => "$left - $right",
          definition: (a, b) => a - b,
        );

  @override
  Node derivative(String variableName) => DifferenceFork(
      left.derivative(variableName),
      right.derivative(
        variableName,
      ));
}

/// A node representing the product of two expressions.

class ProductFork extends Fork {
  ProductFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Product",
          generateTeX: (left, right) =>
              "${left.toTeX()} \\cdot ${right.toTeX()}",
          generateString: (left, right) => "$left * $right",
          definition: (a, b) => a * b,
        );

  @override
  Node derivative(String variableName) => SumFork(
        ProductFork(left, right.derivative(variableName)),
        ProductFork(left.derivative(variableName), right),
      );
}

/// A node representing the quotient of two expressions.
class QuotientFork extends Fork {
  QuotientFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Quotient",
          generateTeX: (left, right) =>
              "\frac{${left.toTeX()}}{${right.toTeX()}}",
          generateString: (left, right) => "($left) / ($right)",
          definition: (a, b) => a / b,
        );
  @override
  Node derivative(String variableName) => QuotientFork(
        DifferenceFork(
          ProductFork(right, left.derivative(variableName)),
          ProductFork(left, right.derivative(variableName)),
        ),
        ProductFork(right, right),
      );
}

/// A node representing the modulus of two expressions.
class ModulusFork extends Fork {
  ModulusFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Modulus",
          generateTeX: (left, right) =>
              "${left.toTeX()} \\bmod ${right.toTeX()}",
          generateString: (left, right) => "$left % $right",
          definition: (a, b) => a % b,
        );

  @override
  Node derivative(String variableName) => throw UnimplementedError(
      "Derivative of modulus function not implemented.");
}

/// A node representing an expression raised to the power of
/// another expression.
class PowerFork extends Fork {
  PowerFork(Node left, Node right)
      : super(
          left: left,
          right: right,
          label: "Power",
          generateTeX: (left, right) => "${left.toTeX()}^{${right.toTeX()}}",
          generateString: (left, right) => "$left ^ $right",
          definition: (a, b) => pow(a, b),
        );

  @override
  Node derivative(String variableName) {
    final (leftIsConstant, rightIsConstant) =
        (isConstant(left), isConstant(right));
    if (!leftIsConstant && rightIsConstant) {
      return ProductFork(
        ProductFork(
            ConstantLeaf(right({})),
            PowerFork(
              left,
              ConstantLeaf(right({}) - 1.0),
            )),
        left.derivative(variableName),
      );
    }
    if (leftIsConstant && !rightIsConstant) {
      return ProductFork(
        ProductFork(
          ConstantLeaf(log(left({}))),
          PowerFork(left, right),
        ),
        right.derivative(variableName),
      );
    }
    return ProductFork(
      this,
      SumFork(
        ProductFork(QuotientFork(right, left), left.derivative(variableName)),
        ProductFork(
          right.derivative(variableName),
          FunctionBranch("log", left),
        ),
      ),
    );
  }
}

/// A node representing a function with two parameters.
class TwoParameterFunctionFork extends Fork {
  TwoParameterFunctionFork(this.name, Node left, Node right)
      : super(
            left: left,
            right: right,
            label: name,
            generateTeX: (left, right) => defs
                .twoParameterFunctionLatexRepresentation[name]!
                .replaceAll("C1", left.toTeX())
                .replaceAll("C2", right.toTeX()),
            generateString: (left, right) => "$name($left, $right)",
            definition: defs.twoParameterFunctionMap[name]!);

  /// The name of the function.
  String name;

  @override
  Node derivative(String variableName) =>
      throw UnimplementedError("Two variable function $name not implemented.");
}
