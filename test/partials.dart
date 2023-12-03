import "package:function_tree/function_tree.dart";

void main() {
  final f = "3 * sin(u * v ^ 2) + 1".toMultiVariableFunction(["u", "v"]);
  // final f = MultiVariableFunction(
  //   fromExpression: "3 * sin(u * v ^ 2) + 1",
  //   withVariables: ["u", "v"],
  // );
  print(f.representation);
  final fu = f.partial("u"), fv = f.partial("v"), pi = "pi".interpret();

  String line(List<num> xs) =>
      [for (final x in xs) x.toStringAsFixed(4).padLeft(8)].join("");

  for (final fun in [f, fu, fv]) {
    print("\n${fun.representation}\n");
    for (var u = -pi / 4; u <= pi / 4; u += pi / 12) {
      print(line([
        for (var v = -pi / 4; v <= pi / 4; v += pi / 12)
          fun({
            "u": u,
            "v": v,
          })
      ]));
    }
  }
}
