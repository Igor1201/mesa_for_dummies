import 'dart:async';
import 'package:args/command_runner.dart';
import 'package:d20/d20.dart';
import 'package:mesa_for_dummies/data/poultice.dart';

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
