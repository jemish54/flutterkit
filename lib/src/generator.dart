import 'dart:io';
import 'package:flutterkit/src/cache.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:mustache_template/mustache.dart';
import 'package:path/path.dart' as p;

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
    await _renderTemplate(
      p.join(cache.path, cache.label, 'config'),
      p.join(projectPath),
      variables,
    );
    await _renderTemplate(
      p.join(cache.path, cache.label, 'project'),
      p.join(projectPath, 'lib'),
      variables,
    );
    progress.complete('Template generated');

    _addDependencies();
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
    Map vars,
  ) async {
    await Directory(to).create(recursive: true);
    await for (final item in Directory(from).list(recursive: true)) {
      final copyTo = p.join(to, p.relative(item.path, from: from));
      if (item is Directory) {
        await Directory(copyTo).create(recursive: true);
      } else if (item is File) {
        final template = Template(await item.readAsString());
        final renderedString = template.renderString(vars);
        await File(copyTo).writeAsString(renderedString);
      } else if (item is Link) {
        await Link(copyTo).create(await item.target(), recursive: true);
      }
    }
  }
}
