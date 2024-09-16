import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterkit/src/cache.dart';

class CleanCommand extends Command {
  @override
  String get description => 'Clean the cached templates';

  @override
  String get name => 'clean';

  @override
  Future<void> run() async {
    final template = argResults?.arguments.firstOrNull;

    final cache = Cache();
    await cache.init();
    await cache.clear(template);
  }
}
