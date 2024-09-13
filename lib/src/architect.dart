import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

class Architect {
  final logger = Logger();

  Future<void> generateProject(String url) async {
    final cache = await _getCacheDirectory();

    final label = url.split('/').last.split('.').first;

    final cloneProgress = logger.progress('Cloning git repository');
    await Process.run(
      'git',
      ['clone', '--depth', '1', url, label],
      workingDirectory: cache,
    );
    cloneProgress.complete('Cloned the repository');

    final copyProgress = logger.progress('Generating project from templete');
    await _copyPath('$cache/$label', '${Directory.current.path}/$label');
    copyProgress.complete('Project Generated');
  }

  Future<String> _getCacheDirectory() async {
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

    return dir.path;
  }

  Future<void> _copyPath(String from, String to) async {
    await Directory(to).create(recursive: true);
    await for (final file in Directory(from).list(recursive: true)) {
      final copyTo = p.join(to, p.relative(file.path, from: from));
      if (file is Directory) {
        await Directory(copyTo).create(recursive: true);
      } else if (file is File) {
        await File(file.path).copy(copyTo);
      } else if (file is Link) {
        await Link(copyTo).create(await file.target(), recursive: true);
      }
    }
  }
}
