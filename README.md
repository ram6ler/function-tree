![](https://bytebucket.org/ram6ler/function-tree/wiki/logo.png?rev=35f49abe6945e6deb48b057e09a788dabb99017a)

Welcome to `function_tree`, a simple library for parsing strings
into callable function-trees.

## Parsing strings as mathematical expressions

At the simplest (and least efficient) level, we can
`interpret` strings as mathematical
expressions.

## Example:

```dart
 final expressions = [
   '2 + 2',
   '(3 + 2)^3',
   '3 * pi / 4',
   '3 * sin(5 * pi / 6)',
   'e^(-1)',
   '2+2-2-2'
 ];
 for (final expression in expressions) {
   print("'$expression' -> ${expression.interpret()}");
 }
```

```text
'2 + 2' -> 4
'(3 + 2)^3' -> 125
'3 * pi / 4' -> 2.356194490192345
'3 * sin(5 * pi / 6)' -> 1.5000000000000009
'e^(-1)' -> 0.36787944117144233
'2+2-2-2' -> 0
```

## Function Trees

The library supports two types of callable,
function-trees, namely `SingleVariableFunction`
and `MultiVariableFunction`.

### Single variable functions

We can create a single variable function from
a string either by constructing a `SingleVariableFunction`
instance or by calling the `toSingleVariableFunction`
string extension directly on a string, as in the following
example:

## Example:

```dart
 final f = '20 * (sin(x) + 1)'.toSingleVariableFunction(),
     pi = 'pi'.interpret();
 for (var x = 0.0; x < 2 * pi; x += pi / 20) {
   print('|' + ' ' * f(x).round() + '*');
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

Similarly, we can construct a `MultiVariableFunction`
instance or call the `toMultiVariableFunction` string extension
to create a multi-variable functional tree, as in
the following example.

## Example:

```dart
 final times = 'a * b'.toMultiVariableFunction(['a', 'b']),
     values = [1, 2, 3, 4, 5];
 for (final a in values) {
   final sb = StringBuffer();
   for (final b in values) {
     sb..write(times({'a': a, 'b': b}))..write('\t');
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

Function tree instances have a `tex` property for
TeX expressions.

## Example:

```dart
 final f = 'x * cos(y) + y * sin(x)'.toMultiVariableFunction(['x', 'y']);
 print(f.tex);
```

```text
x \cdot \cos\left( y \right) + y \cdot \sin\left( x \right)
```

## Interpreter

The interpreter has support for the following:

### Functions

```
abs     acos    asin    atan    ceil
cos     cosh    cot     coth    csc
csch    exp     floor   ln      log
round   sec     sech    sin     sinh
sqrt    tan     tanh
```

### Constants

```
e       pi      ln2     ln10    log2e
log10e  sqrt1_2 sqrt2
```

### Operations

```
+   -   *   /   %   ^
```

## Thanks!

Thanks for your interest in this library. Please file any bugs or requests [here](https://bitbucket.org/ram6ler/function-tree/issues).

