import 'dart:io';
import 'package:flutterkit/src/cache.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

class Generator {
  final String title;
  final Map variables;

  Generator({required this.title, required this.variables});

  final logger = Logger();

  String get projectPath => title == '.'
      ? Directory.current.path
      : p.join(Directory.current.path, title);

  Future<bool> get isValidFlutterProject async =>
      await Directory(p.join(projectPath, 'lib')).exists() &&
      await File(p.join(projectPath, 'pubspec.yaml')).exists();

  Future<void> generate(Cache cache) async {
    final progress = logger.progress('Creating project from template');

    await File(p.join(cache.path, cache.label, 'flutterkit.yml'))
        .copy(p.join(projectPath, 'flutterkit.yml'));
    await _renderTemplate(
      p.join(cache.path, cache.label, 'config'),
      p.join(projectPath),
    );
    await _renderTemplate(
      p.join(cache.path, cache.label, 'project'),
      p.join(projectPath, 'lib'),
    );
    progress.complete('Template generated');

    _addDependencies();
  }

  Future<void> generateModule(Cache cache, String moduleName) async {
    final progress = logger.progress('Creating module from template');

    await _renderTemplate(
      p.join(cache.path, cache.label, 'modules', moduleName),
      p.join(Directory.current.path, variables['path'], title),
    );
    progress.complete('Module generated');
  }

  Future<void> _addDependencies() async {
    final progress = logger.progress('Adding Dependencies');
    await Process.run(
      'dart',
      [
        'pub',
        'add',
        ...variables['dependencies'],
      ],
      workingDirectory: projectPath,
    );
    progress.complete('Added Required Dependencies');
  }

  Future<void> _renderTemplate(
    String from,
    String to,
  ) async {
    await Directory(to).create(recursive: true);

    final updatedVariables = _getAllCaseVariables(variables);

    await for (var entity in Directory(from).list(recursive: true)) {
      final relativePath = p.relative(entity.path, from: from);

      final renderedRelativePath =
          _renderString(relativePath, updatedVariables);

      final targetPath = p.join(to, renderedRelativePath);

      if (entity is Directory) {
        await Directory(targetPath).create(recursive: true);
      } else if (entity is File) {
        final fileContent = await entity.readAsString();
        final renderedContent = _renderString(fileContent, updatedVariables);
        await File(targetPath).writeAsString(renderedContent);
      }
    }
  }

  String _renderString(String template, Map vars) {
    return Template(template).renderString(vars);
  }

  Map _getAllCaseVariables(Map originalVars) {
    final allCaseVars = Map.from(originalVars);

    for (final item in originalVars.entries) {
      if (item.value is String) {
        allCaseVars['${item.key}_titleCase'] = ReCase(item.value).titleCase;
        allCaseVars['${item.key}_snakeCase'] = ReCase(item.value).snakeCase;
        allCaseVars['${item.key}_pascalCase'] = ReCase(item.value).pascalCase;
        allCaseVars['${item.key}_paramCase'] = ReCase(item.value).paramCase;
        allCaseVars['${item.key}_camelCase'] = ReCase(item.value).camelCase;
        allCaseVars['${item.key}_constantCase'] =
            ReCase(item.value).constantCase;
        allCaseVars['${item.key}_dotCase'] = ReCase(item.value).dotCase;
        allCaseVars['${item.key}_headerCase'] = ReCase(item.value).headerCase;
        allCaseVars['${item.key}_pathCase'] = ReCase(item.value).pathCase;
        allCaseVars['${item.key}_sentenceCase'] =
            ReCase(item.value).sentenceCase;
      }
    }
    return allCaseVars;
  }
}
