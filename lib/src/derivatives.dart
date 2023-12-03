//import "dart:math";

import "base.dart" show Node;
import "forks.dart" show DifferenceFork, SumFork, ProductFork, QuotientFork;
import "branches.dart" show FunctionBranch, NegationBranch;
import "leaves.dart" show ConstantLeaf;

/// A mapping of functions to their derivatives.
final Map<String, Node Function(FunctionBranch, String)> derivativesMap = {
  "acos": (f, v) => NegationBranch(
        QuotientFork(
          f.child.derivative(v),
          FunctionBranch(
            "sqrt",
            DifferenceFork(
              ConstantLeaf.one,
              ProductFork(
                f.child,
                f.child,
              ),
            ),
          ),
        ),
      ),
  "asin": (f, v) => QuotientFork(
        f.child.derivative(v),
        FunctionBranch(
          "sqrt",
          DifferenceFork(
            ConstantLeaf.one,
            ProductFork(
              f.child,
              f.child,
            ),
          ),
        ),
      ),
  "atan": (f, v) => QuotientFork(
        f.child.derivative(v),
        SumFork(
          ConstantLeaf.one,
          ProductFork(
            f.child,
            f.child,
          ),
        ),
      ),
  "cos": (f, v) => ProductFork(
      NegationBranch(
        FunctionBranch(
          "sin",
          f.child,
        ),
      ),
      f.child.derivative(v)),
  "cosh": (f, v) => ProductFork(
        FunctionBranch(
          "sinh",
          f.child,
        ),
        f.child.derivative(v),
      ),
  "cot": (f, v) {
    final csc = FunctionBranch(
      "csc",
      f.child,
    );
    return NegationBranch(
      ProductFork(
        f.child.derivative(v),
        ProductFork(
          csc,
          csc,
        ),
      ),
    );
  },
  "coth": (f, v) {
    final csch = FunctionBranch(
      "csch",
      f.child,
    );
    return NegationBranch(
      ProductFork(
        ProductFork(
          csch,
          csch,
        ),
        f.child.derivative(v),
      ),
    );
  },
  "csc": (f, v) => NegationBranch(
        ProductFork(
          ProductFork(
            FunctionBranch(
              "cot",
              f.child,
            ),
            FunctionBranch(
              "csc",
              f.child,
            ),
          ),
          f.child.derivative(v),
        ),
      ),
  "csch": (f, v) => NegationBranch(
        ProductFork(
          ProductFork(
            FunctionBranch(
              "csch",
              f.child,
            ),
            FunctionBranch(
              "coth",
              f.child,
            ),
          ),
          f.child.derivative(v),
        ),
      ),
  "exp": (f, v) => ProductFork(
        f,
        f.child.derivative(v),
      ),
  "ln": (f, v) => QuotientFork(
        f.child.derivative(v),
        FunctionBranch(
          "abs",
          f.child,
        ),
      ),
  "log": (f, v) => QuotientFork(
        f.child.derivative(v),
        FunctionBranch(
          "abs",
          f.child,
        ),
      ),
  "sec": (f, v) => ProductFork(
        ProductFork(
          FunctionBranch(
            "tan",
            f.child,
          ),
          FunctionBranch(
            "sec",
            f.child,
          ),
        ),
        f.child.derivative(v),
      ),
  "sech": (f, v) => NegationBranch(
        ProductFork(
          ProductFork(
            FunctionBranch(
              "sech",
              f.child,
            ),
            FunctionBranch(
              "tanh",
              f.child,
            ),
          ),
          f.child.derivative(v),
        ),
      ),
  "sin": (f, v) => ProductFork(
        FunctionBranch(
          "cos",
          f.child,
        ),
        f.child.derivative(v),
      ),
  "sinh": (f, v) => ProductFork(
        FunctionBranch(
          "cosh",
          f.child,
        ),
        f.child.derivative(v),
      ),
  "sqrt": (f, v) => QuotientFork(
        f.child.derivative(v),
        ProductFork(
          ConstantLeaf(2.0),
          f,
        ),
      ),
  "tan": (f, v) {
    final sec = FunctionBranch(
      "sec",
      f.child,
    );
    return ProductFork(
      ProductFork(
        sec,
        sec,
      ),
      f.child.derivative(v),
    );
  },
  "tanh": (f, v) {
    final sech = FunctionBranch(
      "sech",
      f.child,
    );
    return ProductFork(
      ProductFork(
        sech,
        sech,
      ),
      f.child.derivative(v),
    );
  }
};
