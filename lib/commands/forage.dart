import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:d20/d20.dart';
import 'package:mesa_for_dummies/data/ingredient.dart';

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
      })
      ..removeWhere((Ingredient i, int index) => i == null);

    for (var i = 0; i < bag.length; i++) {
      print('${bag.keys.elementAt(i)?.name}: ${bag.values.elementAt(i)}');
    }
  }
}
