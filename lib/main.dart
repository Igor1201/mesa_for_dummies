import 'dart:async';
import 'package:args/command_runner.dart';
import 'd20.dart';

class ForageCommand extends Command {
  get name => 'forage';
  get description => 'Herbalism foraging helper.';

  ForageCommand()
    : super() {
      argParser
        ..addOption('hours', abbr: 't', defaultsTo: '1', help: 'Number of hours spent foraging.')
        ..addOption('check', abbr: 'c', defaultsTo: '0', help: 'Modifier of your Survival skill check, adding proeficiency in Herbalism Kit if you are not proeficient in the Survival skill.')
        ..addOption('method', abbr: 'm', defaultsTo: 'normal_pace', help: 'Method of search when foraging. One of idle, slow_pace, normal_pace, fast_pace.');
    }

  Future run() async {
  }
}

void main(List<String> arguments) {
  CommandRunner runner = new CommandRunner('mesa_for_dummies', 'Set of utilities to our RPG sessions.')
    ..addCommand(new ForageCommand());
  runner.run(arguments);
}
