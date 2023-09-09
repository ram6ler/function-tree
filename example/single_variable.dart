import "package:function_tree/function_tree.dart";

void main() {
  final f = "sin(2 * x)".toSingleVariableFunction(),
      g = "2 * cos(x)".toSingleVariableFunction(),
      pi = "pi".interpret(),
      width = 30,
      min = -2,
      max = 2,
      spaces = (num y) => ((y - min) / (max - min) * width).round();

  for (var x = 0.0; x < 2 * pi; x += 0.2) {
    final chs = [for (var _ = 0; _ <= width; _++) " "];
    chs[spaces(f(x))] = "+";
    chs[spaces(g(x))] = ":";
    chs[spaces(0)] = "|";

    print(chs.join());
  }
}
