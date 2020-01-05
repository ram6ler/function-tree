![](logo.png)

# function-tree

[Home](home.md) | [Single variable functions](svf.md) | [Multi-variable functions](mvf.md) | [About](about.md) 


## Home

Welcome to *function-tree*, a Dart library for for parsing strings into callable function-trees.

### Using function-tree

Add `function_tree` to your `pubspec.yaml` dependencies as described [at the library's pub page](https://pub.dev/packages/function_tree#-installing-tab-).

### Example session

We can interpret strings as mathematical expressions.

```dart
print('2+2'.interpret());

```


```
4

```


We can use functions and constants we are familiar with.

```dart
print('e^sin(pi / 3)'.interpret()); 

```


```
2.3774426752361646

```


We can parse strings to define single variable functions.

```dart
final f = SingleVariableFunction(fromExpression: 'abs(x^2 - 6 * x +1)');
for (var x = -4.0; x < 6.0; x += 0.5) {
  print('|' + ' ' * f(x).round() + '*');
}

```


```
|                                         *
|                                  *
|                            *
|                      *
|                 *
|            *
|        *
|    *
| *
|  *
|    *
|      *
|       *
|        *
|        *
|        *
|       *
|      *
|    *
|  *

```


(We can also simply call `toSingleVariableFunction` directly
from a string.)

```dart
final f = 'atan(exp(x))'.toSingleVariableFunction();
print(f(3));

```


```
1.5210503339560446

```


We can also create multi-variable functions.

```dart
final f = MultiVariableFunction(
  fromExpression: 'x * y',
  withVariables: ['x', 'y']
);

final values = [1, 2, 3, 4, 5];
for (final y in values) {
  final sb = StringBuffer();
  for (final x in values) {
    sb..write(f({'x': x, 'y': y}))
      ..write('\t');
  }
  print(sb);
}

```


```
1	2	3	4	5	
2	4	6	8	10	
3	6	9	12	15	
4	8	12	16	20	
5	10	15	20	25	

```


(As with single variable functions, we can create multi-variable functions directly from a string.)

```dart
final f = 'exp(atan(x)) + atan(exp(y))'.toMultiVariableFunction(['x', 'y']);
print(f({'x': 2, 'y': 3}));

```


```
4.546769238959674

```



### Syntax

The string expressions used to build the function-trees are similar to expressions that can be used in Dart after importing `dart:math`, such as `3 * sin(x) + 1`. There are several additions, however, including:

* the `^` operator, to raise to a power
* the trigonometric functions, `sec`, `csc` and `cot`, and the hyperbolic functions, `sinh`, `cosh` and `tanh`, are defined.
