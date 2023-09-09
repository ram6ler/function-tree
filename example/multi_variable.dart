import "package:function_tree/function_tree.dart";

void main() {
  final expression = "sqrt(x^2 + x*y + y^2) * log(2, abs(x) + 2) / 1.5",
      f = expression.toMultiVariableFunction(["x", "y"]),
      width = 30,
      from = -3,
      to = 3,
      by = (to - from) / width,
      map = (num t) => from + t * by,
      ch = (num result) => switch (result) {
            > 3 => "█",
            > 2.5 => "▓",
            > 1.5 => "▒",
            > 0.5 => "·",
            _ => " "
          };

  print([
    for (var y = 0; y < width; y++)
      [
        for (var x = 0; x < width; x++) ch(f({"x": map(x), "y": map(y)}))
      ].join("")
  ].join("\n"));
}
