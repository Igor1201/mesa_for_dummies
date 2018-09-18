import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:args/command_runner.dart';
import 'package:d20/d20.dart';
import 'package:mesa_for_dummies/data/ingredient.dart';
import 'package:mesa_for_dummies/data/dnd_beyond.dart';
import 'package:mesa_for_dummies/data/equipment.dart';
import 'package:mesa_for_dummies/data/auth_equipment.dart';

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

  Future<DNDBeyond> getEquipmentsFromServer() async {
    Map<String, String> headers = { HttpHeaders.cookieHeader: Platform.environment['BEYOND_COOKIE'] };
    return http.read('https://www.dndbeyond.com/profile/igor/characters/3615887/json', headers: headers)
        .then((body) => DNDBeyond.fromJson(json.decode(body)['character']));
  }

  Future setEquipment(Equipment equipment) async {
    AuthEquipment authEquipment = AuthEquipment.fromJson(equipment.toJson())
            ..characterId = 3615887
            ..username = 'igor'
            ..csrfToken = '28489d05-2f57-4e81-b1f3-08d30028359b';

    Map<String, String> headers = {
      HttpHeaders.cookieHeader: Platform.environment['BEYOND_COOKIE'],
      HttpHeaders.contentTypeHeader: 'application/json;charset=utf-8',
    };
    return http.post('https://www.dndbeyond.com/api/character/equipment/custom-item/set', headers: headers, body: json.encode(authEquipment.toJson()))
        .then((response) => json.decode(response.body));
  }

  Future run() async {
    List<Equipment> equipments = (await getEquipmentsFromServer()).customItems;

    Map<Ingredient, int> bag = List.filled(hours, 0)
      .map<Ingredient>((_) => _singleForage())
      .toList()
      .fold<Map<Ingredient, int>>(Map<Ingredient, int>(), (b, i) {
        b.update(i, (v) => v + 1, ifAbsent: () => 1);
        return b;
      })
      ..removeWhere((Ingredient i, int index) => i == null);

    for (var i = 0; i < bag.length; i++) {
      Equipment equipment = equipments.firstWhere((Equipment e) => e.name == bag.keys.elementAt(i)?.name);
      Ingredient ingredient = bag.keys.elementAt(i);
      
      if (equipment != null && ingredient != null) {
        print('${ingredient.name}: ${bag.values.elementAt(i)}');
        equipment.quantity += bag.values.elementAt(i);
        
        print(equipment.toJson());
        print(await setEquipment(equipment));
      }
    }
  }
}
