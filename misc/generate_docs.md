# Editing the Project Docs

To ensure that the output in the documentation (readme and project wiki) match the
dart code blocks, do not edit `README.md` or the markdown files in `misc/wiki/out`
directly. Instead, edit `misc/readme/readme_template.md` and the markdown files
in `misc/wiki/in` and then run the script `misc/generate_docs.dart` from within
the project directory. This will overwrite `README.md` and the markdown files in
`misc/wiki/out` with the output from the code snippets in the dart code blocks
inserted.
