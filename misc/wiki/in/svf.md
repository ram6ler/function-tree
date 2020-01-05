## Single variable functions

*function-tree* defines a class called `SingleVariableFunction` that constructs a function-like object from a string representation of a single variable function.

```dart
final f = SingleVariableFunction(fromExpression: '3 * cosh(x)');
print(f(3));
```

By default, `'x'` is taken to be the variable; if this is not what we want, we can state the name of the variable:

```dart
final f = SingleVariableFunction(fromExpression: '3 * cosh(a)', withVariable: 'a');
print(f(3));
```

A more succinct way to construct a `SingleVariableFunction` instance is directly from a string:

```dart
final f = '3 * x'.toSingleVariableFunction();
print(f(100));
```