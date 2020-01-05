![](logo.png)

# function-tree

[Home](home.md) | [Single variable functions](svf.md) | [Multi-variable functions](mvf.md) | [About](about.md) 


## Multi-variable functions

*function-tree* defines a class called `MultiVariableFunction` that constructs a function-like object from a string representation of a multi-variable function.

```dart
final f = MultiVariableFunction(fromExpression: '4 * a + 2 * b', withVariables: ['a', 'b']);
print(f({'a': 10, 'b': 1}));

```


```
42

```


A more succinct way to construct a `MultiVariableFunction` instance is directly from a string:

```dart
final f = 'sin(x) * cos(y)'.toMultiVariableFunction(['x', 'y']);
print(f({'x': 0.5, 'y': 0.5}));

```


```
0.42073549240394825

```

