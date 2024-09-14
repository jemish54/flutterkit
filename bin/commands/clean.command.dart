import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterkit/src/architect.dart';

class CleanCommand extends Command {
  @override
  String get description => 'Clean the cached templates';

  @override
  String get name => 'clean';

  @override
  Future<void> run() async {
    final title = argResults?.arguments.first;
    final org = argResults?['org'];
    final url = argResults?['url'];

    final architect = Architect(title: title, org: org, url: url);
    await architect.generateProject();
  }
}
