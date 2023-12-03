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

```text
'2 + 2' -> 4.0
'(3 + 2)^3' -> 125.0
'3 * pi / 4' -> 2.356194490192345
'3 * sin(5 * pi / 6)' -> 1.5000000000000009
'e^(-1)' -> 0.36787944117144233
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

```text
|                    *
|                       *
|                          *
|                             *
|                                *
|                                  *
|                                    *
|                                      *
|                                       *
|                                        *
|                                        *
|                                        *
|                                       *
|                                      *
|                                    *
|                                  *
|                                *
|                             *
|                          *
|                       *
|                    *
|                 *
|              *
|           *
|        *
|      *
|    *
|  *
| *
|*
|*
|*
| *
|  *
|    *
|      *
|        *
|           *
|              *
|                 *
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

```text
1	2	3	4	5	
2	4	6	8	10	
3	6	9	12	15	
4	8	12	16	20	
5	10	15	20	25	
```

## TeX expressions

Function tree instances have a `tex` property for TeX expressions:

```dart
final f = "x * cos(y) + y * sin(x)".toMultiVariableFunction(["x", "y"]);
print(f.tex);

```

```text
x cdot \cos\left( y \right) + y cdot \sin\left( x \right)
```

## Derivatives

Derivative trees can be constructed through the `SingleVariableFunction.derivative` and `MultiVariableFunction.partial` methods.

```dart
final f = "(2 * x) ^ (1 / (x ^ 2))".toSingleVariableFunction(), 
    fDash = f.derivative("x");
print("x      y      y'");
for (var x = 0.5; x < 3.0; x += 0.25) {
  print(
    "${x.toStringAsFixed(4)} "
    "${f(x).toStringAsFixed(4)} "
    "${fDash(x).toStringAsFixed(4)}");
}
```

```text
x      y      y'
0.5000 1.0000 8.0000
0.7500 2.0561 0.9215
1.0000 2.0000 -0.7726
1.2500 1.7976 -0.7663
1.5000 1.6295 -0.5780
1.7500 1.5054 -0.4229
2.0000 1.4142 -0.3134
2.2500 1.3460 -0.2373
2.5000 1.2937 -0.1837
2.7500 1.2529 -0.1452
```

```dart
final f = "sin(u ^ 2 + 2 * v)".toMultiVariableFunction(["u", "v"]), 
  fu = f.partial("u"), 
  fv = f.partial("v"),
  pi = "pi".interpret(),
  u = pi / 3,
  v = pi / 4;
  for (final fun in [f, fu, fv]) {
    print("${fun({"u": u, "v": v})}");
  }
```

```text
0.4566033934365143
-1.8633212348878314
-1.779340710602958
```

## Interpreter

The interpreter has support for the following:

### Functions

#### One-parameter functions

```
abs     acos    asin    atan    ceil
cos     cosh    cot     coth    csc
csch    exp     fact    floor   ln      
log     round   sec     sech    sin
sinh    sqrt    tan     tanh
```

#### Two-parameter functions

```
log     nrt     pow
```

### Constants

```
e       pi      ln2     ln10    log2e
log10e  sqrt1_2 sqrt2
```

### Operations

```
+  -  *  /  %  ^
```

## Thanks

Thanks for your interest in this library. Please file any bugs or
requests [here](https://github.com/ram6ler/function-tree/issues).
