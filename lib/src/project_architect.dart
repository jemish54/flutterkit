import 'dart:io';

import 'package:flutterkit/src/generator.dart';
import 'package:mason_logger/mason_logger.dart';

import 'cache.dart';

class ProjectArchitect {
  String? title;
  final String? org;
  final String? url;
  final String? branch;

  ProjectArchitect({
    this.title,
    this.org,
    this.url,
    this.branch,
  });

  final cache = Cache();
  final logger = Logger();

  Future<void> generateProject() async {
    if (title == null) {
      logger.err('No title provided for project creation');
      return;
    }

    if (title != '.') {
      await _createFlutterProject();
    }

    if (url == null) {
      return;
    }

    await cache.init();
    cache.setUrl(url!, branch);
    await cache.ensureCached();

    var vars = await cache.parseVariables(title!);

    final generator = Generator(
      title: title!,
      variables: vars,
    );

    if (!await generator.isValidFlutterProject) {
      logger.err('Please run command in a valid flutter project');
      return;
    }

    await generator.generate(cache);
  }

  Future<void> _createFlutterProject() async {
    final progress = logger.progress('Creating Base Flutter Project');
    await Process.run(
      'flutter',
      [
        'create',
        title!,
        if (org != null) ...['--org', org!],
      ],
    );
    progress.complete('Flutter Project Created');
  }
}
