import 'package:args/command_runner.dart';
import 'package:mesa_for_dummies/commands/forage.dart';
import 'package:mesa_for_dummies/commands/craft.dart';

void main(List<String> arguments) {
  CommandRunner runner = CommandRunner(
      'mesa_for_dummies', 'Set of utilities to our RPG sessions.')
    ..addCommand(CraftCommand())
    ..addCommand(ForageCommand());
  runner.run(arguments);
}
