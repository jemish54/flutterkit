import 'package:args/command_runner.dart';

import 'commands/create.command.dart';
import 'commands/clean.command.dart';
import 'commands/module.command.dart';

void main(List<String> args) async {
  final runner = CommandRunner(
    'flutterkit',
    'A CLI for Flutter Project Module Management',
  )
    ..addCommand(CreateCommand())
    ..addCommand(CleanCommand())
    ..addCommand(ModuleCommand());

  await runner.run(args);
}
