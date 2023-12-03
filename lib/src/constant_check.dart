import "base.dart" show Node;
import "branches.dart" show Branch;
import "forks.dart" show Fork;
import "leaves.dart" show ConstantLeaf, SpecialConstantLeaf;

bool isConstant(Node node) => switch (node) {
      ConstantLeaf() || SpecialConstantLeaf() => true,
      Fork(:var left, :var right) => isConstant(left) && isConstant(right),
      Branch(:var child) => isConstant(child),
      _ => false
    };
