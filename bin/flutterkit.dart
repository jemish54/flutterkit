import 'package:args/command_runner.dart';

import 'commands/create.command.dart';

void main(List<String> args) async {
  final runner = CommandRunner(
    'flutterkit',
    'A CLI for Flutter Project Module Management',
  )..addCommand(CreateCommand());

  await runner.run(args);
}
