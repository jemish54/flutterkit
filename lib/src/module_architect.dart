import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'package:flutterkit/src/generator.dart';

import 'cache.dart';

class ModuleArchitect {
  String moduleName;
  String title;

  ModuleArchitect({
    required this.moduleName,
    required this.title,
  });

  final cache = Cache();
  final logger = Logger();

  Future<bool> get isValidForModuleCreation async =>
      await File(p.join(Directory.current.path, 'flutterkit.yml')).exists();

  Future<void> generateModule() async {
    if (!await isValidForModuleCreation) {
      logger.err('flutterkit.yml not present in project');
    }

    final progress = logger.progress('Generating module');
    try {
      await cache.init();
      final kitVars = await _getVarsFromKitFile();
      cache.setUrl(kitVars['url']);

      await cache.ensureCached();

      final moduleVars = await _getVarsForModule(
        p.join(cache.path, cache.label),
      );

      final generator = Generator(
        title: title,
        variables: Map.from(kitVars)
          ..remove('dependencies')
          ..addEntries(moduleVars.entries),
      );
      await generator.generateModule(cache, moduleName);

      progress.complete('$title module generated');
    } catch (e) {
      progress.fail(e.toString());
    }
  }

  Future<Map> _getVarsFromKitFile() async {
    final yaml = await File(p.join(Directory.current.path, 'flutterkit.yml'))
        .readAsString();
    return loadYaml(yaml);
  }

  Future<Map> _getVarsForModule(String templatePath) async {
    final file = File(p.join(templatePath, 'modules', 'modules.yml'));
    if (!await file.exists()) {
      throw Exception('Modules directory is missing configuration');
    }
    final yaml = await file.readAsString();
    return Map.from(loadYaml(yaml)[moduleName])
      ..putIfAbsent(
        'module_name',
        () => title,
      );
  }
}
