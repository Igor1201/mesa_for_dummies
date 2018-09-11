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

  final List<Ingredient> _ingredients = List()
    ..add(Ingredient([2, 12], 'Wisp\'s Breath', 'Slows intoxication.'))
    ..add(Ingredient([3, 11], 'Blue Cap', 'Slows infection from common diseases.'))
    ..add(Ingredient([4, 10], 'Spur Root', 'Reduces visible scarring.'))
    ..add(Ingredient([5, 9], 'Lavender Seeds', 'Masks your scent.'))
    ..add(Ingredient([6, 7, 8], 'Royal Lichen', 'Recover maximum from next hit die rolled within 1 minute.'));
  final List<Ingredient> _specialIngredients = List()
    ..add(Ingredient([1], 'Rinwort', 'Halts petrification.', isSpecial: true))
    ..add(Ingredient([2], 'Dried Ginko Leaf', '+5 bunos to Passive Perception for 1 hour.', isSpecial: true))
    ..add(Ingredient([3], 'Hewleaf', 'Common antitoxin.', isSpecial: true))
    ..add(Ingredient([4], 'Hyssop Dew', 'Darkvision (30 ft.) for 1 hour.', isSpecial: true))
    ..add(Ingredient([5], 'Lilythistle', 'Can hold breath for double your normal time.', isSpecial: true))
    ..add(Ingredient([6], 'Silver Thornberry', 'Heals for 1 hit point.', isSpecial: true));
  Future run() async {

enum ApplicationType {
  Unspecified, Ingested, Topical,
}

class Ingredient {
  final List<int> rolls;
  final String name;
  final String effect;
  final bool isSpecial;
  final ApplicationType application;

  Ingredient(this.rolls, this.name, this.effect, {this.isSpecial = false, this.application = ApplicationType.Unspecified});

  @override
  String toString() {
    return '${rolls} ${name}${isSpecial ? '*' : ''}: ${effect}';
  }
}

void main(List<String> arguments) {
  CommandRunner runner = new CommandRunner('mesa_for_dummies', 'Set of utilities to our RPG sessions.')
    ..addCommand(new ForageCommand());
  runner.run(arguments);
}
