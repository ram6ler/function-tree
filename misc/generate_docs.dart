import "dart:io";

final header = """
![](logo.png)

# Function Tree

[Home](home.md) | [Single variable functions](svf.md) | [Multi-Variable functions](mvf.md) | [About](about.md) 

""",
    backgroundCodeTemplate = """
import "package:function_tree/function_tree.dart";

void main() {
  [CODE]
}
""";

Future<void> main(List<String> args) async {
  const spew = 0, code = 1;
  var mode = spew,
      codeCollector = StringBuffer(),
      fileCollector = StringBuffer();

  Future<void> populateFile(String inPath, String outPath) async {
    for (final line in await File(inPath).readAsLines()) {
      switch (mode) {
        case spew:
          if (line == "```dart") {
            mode = code;
          }
          fileCollector.writeln(line);
          break;
        case code:
          if (line == "```") {
            fileCollector
              ..writeln(codeCollector)
              ..writeln(line)
              ..writeln("\n")
              ..writeln("```text");
            await File("temp.dart").writeAsString(backgroundCodeTemplate
                .replaceAll("[CODE]", codeCollector.toString()));
            fileCollector
                .writeln((await Process.run("dart", ["temp.dart"])).stdout);
            await File("temp.dart").delete();
            ;
            fileCollector.writeln("$line\n");

            codeCollector.clear();
            mode = spew;
          } else {
            codeCollector.writeln(line);
          }
          break;
      }
    }
    await File(outPath).writeAsString(fileCollector.toString());
  }

  // Wiki
  for (final wiki in ["about", "home", "mvf", "svf"]) {
    fileCollector.clear();
    fileCollector.writeln(header);
    await populateFile("misc/wiki/in/$wiki.md", "misc/wiki/out/$wiki.md");
  }
  // Readme
  fileCollector.clear();
  await populateFile("misc/readme/readme_template.md", "README.md");
}
