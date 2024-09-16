import 'dart:convert';
import 'dart:io';
import 'package:flutterkit/src/yaml_writer.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

class Cache {
  final logger = Logger();
  late final String _path;
  late final String _url;

  Future<void> init() async {
    String home;

    if (Platform.isLinux || Platform.isMacOS) {
      home = Platform.environment['HOME']!;
    } else if (Platform.isWindows) {
      home = Platform.environment['USERPROFILE']!;
    } else {
      throw Exception('Platform not supported');
    }

    final dir = Directory(p.join(home, '.flutterkit'));
    if (!await dir.exists()) {
      await dir.create();
    }

    _path = dir.path;
  }

  void setUrl(String url) => _url = url;
  String get label => _url.split('/').last.split('.').first;

  String get path => _path;

  Future<void> ensureCached() async {
    if (!await Directory(p.join(path, label)).exists()) {
      await cloneToCache();
    }
  }

  Future<void> cloneToCache() async {
    final cloneProgress = logger.progress('Cloning git repository');
    await Process.run(
      'git',
      ['clone', '--depth', '1', _url, label],
      workingDirectory: path,
    );
    cloneProgress.complete('Cloned the repository');
  }

  Future<Map> parseVariables(String title) async {
    final yaml =
        await File(p.join(path, label, 'flutterkit.yml')).readAsString();
    final vars = loadYaml(yaml);

    logger.success(const JsonEncoder.withIndent('    ')
        .convert(Map.from(vars)..remove('dependencies')));

    final writer = YamlWriter();
    final updatedVars = Map.from(vars)
      ..update(
        'title',
        (value) => title,
        ifAbsent: () => title,
      )
      ..update(
        'url',
        (value) => _url,
        ifAbsent: () => _url,
      );
    final updatedYaml = writer.write(
      updatedVars,
    );

    await File(p.join(path, label, 'flutterkit.yml'))
        .writeAsString(updatedYaml);

    return updatedVars;
  }

  Future<void> clear(String? template) async {
    try {
      if (template == null) {
        await Directory(path).delete(recursive: true);
        return;
      }
      await Directory(p.join(path, template)).delete(recursive: true);
      // ignore: empty_catches
    } catch (e) {}
  }
}
