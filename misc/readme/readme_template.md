# Function Tree

Welcome to `function_tree`, a simple library for parsing strings into
callable function-trees.

## Parsing strings as mathematical expressions

At the simplest (and least efficient) level, we can `interpret` strings as
mathematical expressions:

```dart
final expressions = [
  "2 + 2",
  "(3 + 2)^3",
  "3 * pi / 4",
  "3 * sin(5 * pi / 6)",
  "e^(-1)"
];
for (final expression in expressions) {
  print("'$expression' -> ${expression.interpret()}");
}
```

## Function Trees

The library supports two types of callable, function-trees, namely
`SingleVariableFunction` and `MultiVariableFunction`.

### Single variable functions

We can create a single variable function from a string either by constructing
a `SingleVariableFunction` instance or by calling the `toSingleVariableFunction`
string extension directly on a string, as in the following example.

```dart
final f = "20 * (sin(x) + 1)".toSingleVariableFunction(),
    pi = "pi".interpret();
for (var x = 0.0; x < 2 * pi; x += pi / 20) {
  print("|" + " " * f(x).round() + "*");
}
```

### Multi-variable functions

Similarly, we can construct a `MultiVariableFunction` instance or call the
`toMultiVariableFunction` string extension to create a multi-variable function
tree, as in the following example.

```dart
final times = "a * b".toMultiVariableFunction(["a", "b"]),
    values = [1, 2, 3, 4, 5];
for (final a in values) {
  final sb = StringBuffer();
  for (final b in values) {
    sb
      ..write(times({"a": a, "b": b}).floor())
      ..write("\t");
  }
  print(sb);
}
```

## TeX expressions

Function tree instances have a `tex` property for TeX expressions:

```dart
final f = "x * cos(y) + y * sin(x)".toMultiVariableFunction(["x", "y"]);
print(f.tex);
```

## Interpreter

The interpreter has support for the following:

### Functions

#### One-parameter functions

```text
abs     acos    asin    atan    ceil
cos     cosh    cot     coth    csc
csch    exp     floor   ln      log
round   sec     sech    sin     sinh
sqrt    tan     tanh
```

#### Two-parameter functions

```text
log     nrt     pow
```

### Constants

```text
e       pi      ln2     ln10    log2e
log10e  sqrt1_2 sqrt2
```

### Operations

```text
+  -  *  /  %  ^
```

## Thanks

Thanks for your interest in this library. Please file any bugs or
requests [here](https://github.com/ram6ler/function-tree/issues).
