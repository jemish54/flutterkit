import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterkit/src/project_architect.dart';

class CreateCommand extends Command {
  @override
  String get description => 'Create project from git templete';

  @override
  String get name => 'create';

  CreateCommand() {
    argParser
      ..addOption('org', help: 'Organization name (reversed domain)')
      ..addOption('url', help: 'Git Repository Url for Template');
  }

  @override
  Future<void> run() async {
    final title = argResults?.arguments.first;
    final org = argResults?['org'];
    final url = argResults?['url'];

    final architect = ProjectArchitect(title: title, org: org, url: url);
    await architect.generateProject();
  }
}
