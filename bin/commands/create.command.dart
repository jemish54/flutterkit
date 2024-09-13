import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterkit/src/architect.dart';

class CreateCommand extends Command {
  @override
  String get description => 'Create project from git templete';

  @override
  String get name => 'create';

  @override
  Future<void> run() async {
    final url = argResults?.arguments.first;

    if (url == null) return;

    final architect = Architect();
    await architect.generateProject(url);
  }
}
