/// Returns a sanitized version of `expression`.
String cleanExpression(String expression) {
  final junk = RegExp(r"[^0-9a-zA-Z_.+\-/*%^(),]"),
      factorial = RegExp(r"([0-9]+) *!");
  if (factorial.hasMatch(expression)) {
    expression = expression.replaceAllMapped(
        factorial, (match) => "fact(${match.group(1)!})");
  }
  expression = expression.replaceAll(junk, "");
  var hit = true;
  while (hit) {
    hit = false;
    for (final (String junk, String r) in [
      ("--", "+"),
      ("-+", "-"),
      ("+-", "-"),
      ("++", "+"),
      // Special negation character.
      ("/-", "/~"),
      ("*-", "*~")
    ]) {
      if (expression.contains(junk)) {
        hit = true;
        expression = expression.replaceFirst(junk, r);
      }
    }
  }
  return expression;
}

/// Returns a sanitized version of `tex`.
String cleanTeX(String tex) {
  final patternStart = r"\left( \left(", patternEnd = r"\right) \right)";
  while (tex.contains(patternStart)) {
    final start = tex.indexOf(patternStart),
        end = indexOfClosingParenthesis(tex, start, patternStart, patternEnd);
    tex = tex
        .replaceFirst(patternStart, r"\left(       ", start)
        .replaceFirst(patternEnd, r"\right)        ", end);
  }
  return tex.replaceAll(RegExp(" +"), " ").trim();
}

/// Returns the index of the closure of the parenthesis opening at `start`.
int indexOfClosingParenthesis(String expression,
    [int start = 0, String open = "(", String close = ")"]) {
  int level = 0, index;
  for (index = start; index < expression.length; index++) {
    if (expression.substring(index, index + open.length) == open) {
      level++;
      index += open.length - 1;
    } else if (expression.substring(index, index + close.length) == close) {
      level--;
      if (level == 0) {
        break;
      }
      index += close.length - 1;
    }
  }
  return level == 0 ? index : -1;
}

/// Checks whether all parentheses in `expression` are closed.
bool parenthesesAreBalanced(String expression) {
  var level = 0;
  for (var i = 0; i < expression.length; i++) {
    if (expression[i] == "(") {
      level++;
    } else if (expression[i] == ")") {
      level--;
    }
  }
  return level == 0;
}

/// Counts the number of commas in `expression`.
int numberOfCommas(String expression) {
  if (expression.isEmpty) {
    return 0;
  }
  final index = expression.indexOf(",");
  if (index == -1) {
    return 0;
  }
  if (index == expression.length - 1) {
    return 1;
  }
  return 1 + numberOfCommas(expression.substring(index + 1));
}
