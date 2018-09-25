import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:args/command_runner.dart';
import 'package:d20/d20.dart';
import 'package:mesa_for_dummies/data/poultice.dart';
import 'package:mesa_for_dummies/data/dnd_beyond.dart';
import 'package:mesa_for_dummies/data/equipment.dart';
import 'package:mesa_for_dummies/data/auth_equipment.dart';

class CraftCommand extends Command {
  get name => 'craft';
  get description => 'Herbalism crafting helper.';

  CraftCommand() : super() {
    argParser
      ..addOption('check',
          abbr: 'c',
          defaultsTo: '0',
          help:
              'Modifier of your Wisdom crafting check, using your proeficiency in Herbalism Kit.')
      ..addOption('poultice',
          abbr: 'p',
          help:
              'The poultice you\'re trying to craft. One of: wisps_breath, blue_cap, spur_root, lavender_seeds, royal_lichen, rinwort, dried_ginko, hewleaf, hyssop_dew, lilythistle, silver_thornberry.');
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

  Future<DNDBeyond> getEquipmentsFromServer() async {
    Map<String, String> headers = {
      HttpHeaders.cookieHeader: Platform.environment['BEYOND_COOKIE']
    };
    return http
        .read('https://www.dndbeyond.com/profile/igor/characters/3615887/json',
            headers: headers)
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
    return http
        .post(
            'https://www.dndbeyond.com/api/character/equipment/custom-item/set',
            headers: headers,
            body: json.encode(authEquipment.toJson()))
        .then((response) => json.decode(response.body));
  }

  Future run() async {
    List<Equipment> equipments = (await getEquipmentsFromServer()).customItems;
    Equipment equipmentPoultice = equipments.firstWhere(
        (Equipment e) => e.name == '${poultice.ingredient.name} Poultice');
    Equipment equipmentIngredient = equipments
        .firstWhere((Equipment e) => e.name == poultice.ingredient.name);

    if (equipmentPoultice != null &&
        equipmentIngredient != null &&
        poultice != null) {
      if (equipmentIngredient.quantity < poultice.quantity) {
        print('''
Crafting was NOT successful.
Not enough ingredients.
        ''');
        return;
      }

      bool successful = _singleCraft(poultice);
      print('''
Crafting was${!successful ? ' NOT' : ''} successful.
You have spent ${poultice.quantity}x ${poultice.ingredient.name} and 10 minutes.
      ''');

      equipmentIngredient.quantity -= poultice.quantity;
      await setEquipment(equipmentIngredient);
      if (successful) {
        print('''
You have crafted a ${poultice.ingredient.name} Poultice.
        ''');
        equipmentPoultice.quantity += 1;
        await setEquipment(equipmentPoultice);
      }
    }
  }
}
