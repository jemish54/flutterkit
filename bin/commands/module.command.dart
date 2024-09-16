import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:flutterkit/src/module_architect.dart';
import 'package:mason_logger/mason_logger.dart';

class ModuleCommand extends Command {
  @override
  String get description => 'Create single module from templete';

  @override
  String get name => 'module';

  @override
  Future<void> run() async {
    final moduleName = argResults?.arguments.elementAtOrNull(0);
    final title = argResults?.arguments.elementAtOrNull(1);

    if (moduleName == null) {
      Logger().err('Please provide Module Template name');
      return;
    }
    if (title == null) {
      Logger().err('Please provide Module Title');
      return;
    }

    final architect = ModuleArchitect(moduleName: moduleName, title: title);
    await architect.generateModule();
  }
}
