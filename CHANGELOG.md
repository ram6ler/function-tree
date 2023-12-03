# Change log

## 0.9.1

- Added the ability to create symbolic derivatives from single variable functions.

## 0.9.0

- Incorporated Dart 3 features.
- More resilient to repeated negation / confirmation.
- Added a representation method on trees to show structure.
- Added a `toString` representation of nodes and function trees.
- Cleaned up the code base to be easier to read and to better match the dart.dev recommendations.
- Interpreter shakes out some unnecessary components, such as parentheses surrounding constants, while generating tree.

## 0.8.13

- Allow unary + or - to directly follow the *, /, ^ or % operators.

## 0.8.12

- Parse numbers as `double`s instead of `num`s to prevents common use case issues with large integers.

## 0.8.11

- Oh dear! This time with debug mode off!

## 0.8.1

- Fixed unary sign bug that treated expressions like -a+b as -(a+b). Wow!

## 0.8.0-dev.1

- Added null safety!
- String interpolation appears even slower than before, but the generated function trees are still pretty efficient (once generated, within an order of magnitude of native Dart math library functions).

## 0.7.0

- Added functionality for two-parameter functions, `log`, `nrt` and `pow` in response to a feature request.

## 0.6.0

- Important bug fix: differences

## 0.5.0

- Dusted out some cobwebs.
- Renamed `FunctionTree` `MultiVariableFunction` and `FunctionOfX` `SingleVariableFunction`, which is more expressive.
- Removed zero, derivative and integral estimates, which I feel were tangential.

## 0.2.6

Fixed ambiguity issue: if the user chooses a variable name in an expression that happens to be a special constant name (such as 'e'), the parser will take occurrences in the expression to mean that the variable.

## 0.2.5

- Marked as ready for Dart 2.
- dartfmt-ed some of the files.
- Added support for the `%` operator.
- Added support for `floor`, `ceil` and `round`.
- Added come timing comparisons between evaluating native Dart functions, function tree instances and repeated string parsing in `test/`.

## 0.2.0

- Re-wrote the parsing engine: code much cleaner and easier to read.
- Cleared out deprecated dart:math constants.
- Updated code for Dart 2.
- Added support for `abs`.

## 0.1.1

- Basic numerical differentiation.
- Basic numerical integration (Simpson).
- Basic zero-finding (Newton).
- Very much proof of concept.

## 0.1.0

- Initial version, proof of concept.
- Very little checking of input at this stage.
