import 'dart:io';

final header = '''
![](logo.png)

# function-tree

[Home](home.md) | [Single variable functions](svf.md) | [Multi-variable functions](mvf.md) | [About](about.md) 

''',
    template = '''
import 'package:function_tree/function_tree.dart';

void main() {
  [CODE]
}
''';

Future<void> main(List<String> args) async {
  const spew = 0, code = 1;
  var mode = spew;
  final filename = args.first, sb = StringBuffer();

  print(header);

  for (final line in await File(filename).readAsLines()) {
    switch (mode) {
      case spew:
        if (line == '```dart') {
          mode = code;
        }
        print(line);
        break;
      case code:
        if (line == '```') {
          print(sb);
          print(line);
          print('\n');
          print(line);
          await File('temp.dart')
              .writeAsString(template.replaceAll('[CODE]', sb.toString()));
          print((await Process.run('dart', ['temp.dart'])).stdout);
          await File('temp.dart').delete();
          ;
          print('$line\n');

          sb.clear();
          mode = spew;
        } else {
          sb.writeln(line);
        }
        break;
    }
  }
}
