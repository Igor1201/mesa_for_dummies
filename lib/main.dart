import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:d20/d20.dart';

enum ForagingMethod {
  idle, slow_pace, normal_pace, fast_pace,
}

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

  final D20 _d20 = D20();
  final List<Ingredient> _ingredients = List()
    ..add(Ingredient.WispsBreath)
    ..add(Ingredient.BlueCap)
    ..add(Ingredient.SpurRoot)
    ..add(Ingredient.LavenderSeeds)
    ..add(Ingredient.RoyalLichen);
  final List<Ingredient> _specialIngredients = List()
    ..add(Ingredient.Rinwort)
    ..add(Ingredient.DriedGinkoLeaf)
    ..add(Ingredient.Hewleaf)
    ..add(Ingredient.HyssopDew)
    ..add(Ingredient.Lilythistle)
    ..add(Ingredient.SilverThornberry);
  final Map<ForagingMethod, int> _methodTable = Map()
    ..putIfAbsent(ForagingMethod.idle, () => 10)
    ..putIfAbsent(ForagingMethod.slow_pace, () => 15)
    ..putIfAbsent(ForagingMethod.normal_pace, () => 18)
    ..putIfAbsent(ForagingMethod.fast_pace, () => 21);

  int get hours => int.parse(argResults['hours']);
  int get check => int.parse(argResults['check']);
  ForagingMethod get method {
    return ForagingMethod.values.firstWhere((f) => f.toString() == 'ForagingMethod.${argResults['method']}', orElse: () => null);
  }

  Ingredient _singleForage() {
    int roll = _d20.roll('1d20');
    if (roll == 20) {
      int forageRoll = _d20.roll('1d6');
      return _specialIngredients.firstWhere((i) => i.rolls.contains(forageRoll));
    } else if (roll + check >= _methodTable[method]) {
      int forageRoll = _d20.roll('2d6');
      return _ingredients.firstWhere((i) => i.rolls.contains(forageRoll));
    }
    return null;
  }

  Future run() async {
    Map<Ingredient, int> bag = List.filled(hours, 0)
      .map<Ingredient>((_) => _singleForage())
      .toList()
      .fold<Map<Ingredient, int>>(Map<Ingredient, int>(), (b, i) {
        b.update(i, (v) => v + 1, ifAbsent: () => 1);
        return b;
      });

    for (var i = 0; i < bag.length; i++) {
      print('${bag.keys.elementAt(i)?.name}: ${bag.values.elementAt(i)}');
    }
  }
}

class CraftCommand extends Command {
  get name => 'craft';
  get description => 'Herbalism crafting helper.';

  CraftCommand()
    : super() {
      argParser
        ..addOption('check', abbr: 'c', defaultsTo: '0', help: 'Modifier of your Wisdom crafting check, using your proeficiency in Herbalism Kit.')
        ..addOption('poultice', abbr: 'p', help: 'The poultice you\'re trying to craft. Eg: wisps_breath, dried_ginko, hewleaf.');
    }

  final D20 _d20 = D20();
  final Map<String, Poultice> _poulticeTable = Map()
    ..putIfAbsent('wisps_breath', () => Poultice.WispsBreath)
    ..putIfAbsent('blue_cap', () => Poultice.BlueCap)
    ..putIfAbsent('spur_root', () => Poultice.SpurRoot)
    ..putIfAbsent('lavender_seeds', () => Poultice.LavenderSeeds)
    ..putIfAbsent('royal_lichen', () => Poultice.RoyalLichen)
    ..putIfAbsent('rinwort', () => Poultice.Rinwort)
    ..putIfAbsent('dried_ginko', () => Poultice.DriedGinko)
    ..putIfAbsent('hewleaf', () => Poultice.Hewleaf)
    ..putIfAbsent('hyssop_dew', () => Poultice.HyssopDew)
    ..putIfAbsent('lilythistle', () => Poultice.Lilythistle)
    ..putIfAbsent('silver_thornberry', () => Poultice.SilverThornberry);

  int get check => int.parse(argResults['check']);
  Poultice get poultice {
    return _poulticeTable[argResults['poultice']];
  }

  bool _singleCraft(Poultice poultice) {
    int roll = _d20.roll('1d20+${check}');
    return roll >= poultice.check;
  }

  Future run() async {
    bool successful = _singleCraft(poultice);
    print('''
Crafting was${!successful ? ' NOT' : ''} successful.
You have spent ${poultice.quantity}x ${poultice.ingredient.name} and 10 minutes.
    ''');
  }
}

enum ApplicationType {
  Unspecified, Ingested, Topical,
}

class Ingredient {
  final List<int> rolls;
  final String name;
  final String effect;
  final bool isSpecial;
  final ApplicationType application;

  const Ingredient(this.rolls, this.name, this.effect, {this.isSpecial = false, this.application = ApplicationType.Unspecified});

  @override
  String toString() {
    return '${rolls} ${name}${isSpecial ? '*' : ''}: ${effect}';
  }

  static const WispsBreath = Ingredient([2, 12], 'Wisp\'s Breath', 'Slows intoxication.');
  static const BlueCap = Ingredient([3, 11], 'Blue Cap', 'Slows infection from common diseases.');
  static const SpurRoot = Ingredient([4, 10], 'Spur Root', 'Reduces visible scarring.');
  static const LavenderSeeds = Ingredient([5, 9], 'Lavender Seeds', 'Masks your scent.');
  static const RoyalLichen = Ingredient([6, 7, 8], 'Royal Lichen', 'Recover maximum from next hit die rolled within 1 minute.');

  static const Rinwort = Ingredient([1], 'Rinwort', 'Halts petrification.', isSpecial: true);
  static const DriedGinkoLeaf = Ingredient([2], 'Dried Ginko Leaf', '+5 bunos to Passive Perception for 1 hour.', isSpecial: true);
  static const Hewleaf = Ingredient([3], 'Hewleaf', 'Common antitoxin.', isSpecial: true);
  static const HyssopDew = Ingredient([4], 'Hyssop Dew', 'Darkvision (30 ft.) for 1 hour.', isSpecial: true);
  static const Lilythistle = Ingredient([5], 'Lilythistle', 'Can hold breath for double your normal time.', isSpecial: true);
  static const SilverThornberry = Ingredient([6], 'Silver Thornberry', 'Heals for 1 hit point.', isSpecial: true);
}

class Poultice {
  final Ingredient ingredient;
  final String effect;
  final int quantity;
  final int check;
  final bool isSpecial;
  final ApplicationType application;

  const Poultice(this.ingredient, this.quantity, this.check, this.effect, {this.isSpecial = false, this.application = ApplicationType.Unspecified});

  @override
  String toString() {
    return '[${check}] ${quantity}x ${ingredient.name}: ${effect}';
  }

  static const WispsBreath = Poultice(Ingredient.WispsBreath, 6, 17, 'Cures hangover and removes one level of exhaustion.');
  static const BlueCap = Poultice(Ingredient.BlueCap, 5, 15, 'Cures common disease.');
  static const SpurRoot = Poultice(Ingredient.SpurRoot, 3, 19, 'Starts regrowth of minor appendage, such as a finger.');
  static const LavenderSeeds = Poultice(Ingredient.LavenderSeeds, 5, 18, 'Advantage on Dexterity (Stealth) checks for 1 minute.');
  static const RoyalLichen = Poultice(Ingredient.RoyalLichen, 5, 20, 'Heals for 2d4 + 2 hit points.');

  static const Rinwort = Poultice(Ingredient.Rinwort, 4, 18, 'Reverses total petrification.', isSpecial: true);
  static const DriedGinko = Poultice(Ingredient.DriedGinkoLeaf, 3, 15, 'Cannot be surprised for 1d4 hours.', isSpecial: true);
  static const Hewleaf = Poultice(Ingredient.Hewleaf, 4, 20, 'Immune to poisoned condition and resistant to poison damage for 1 hour.', isSpecial: true);
  static const HyssopDew = Poultice(Ingredient.HyssopDew, 3, 19, 'Advantage on all sight based Wisdom (Perception) and Intelligence (Investigation) checks for 1d4 hours.', isSpecial: true);
  static const Lilythistle = Poultice(Ingredient.Lilythistle, 4, 18, 'Do not need air for 1 hour.', isSpecial: true);
  static const SilverThornberry = Poultice(Ingredient.SilverThornberry, 5, 20, 'Heals for 4d4 + 4 hit points.', isSpecial: true);
}

void main(List<String> arguments) {
  CommandRunner runner = new CommandRunner('mesa_for_dummies', 'Set of utilities to our RPG sessions.')
    ..addCommand(new CraftCommand())
    ..addCommand(new ForageCommand());
  runner.run(arguments);
}
