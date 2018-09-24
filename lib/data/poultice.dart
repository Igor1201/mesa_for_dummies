import 'package:mesa_for_dummies/data/ingredient.dart';

class Poultice {
  final Ingredient ingredient;
  final String effect;
  final int quantity;
  final int check;
  final bool isSpecial;

  const Poultice(this.ingredient, this.quantity, this.check, this.effect,
      {this.isSpecial = false});

  @override
  String toString() {
    return '[${check}] ${quantity}x ${ingredient.name}: ${effect}';
  }

  static const WispsBreath = Poultice(Ingredient.WispsBreath, 6, 17,
      'Cures hangover and removes one level of exhaustion.');
  static const BlueCap =
      Poultice(Ingredient.BlueCap, 5, 15, 'Cures common disease.');
  static const SpurRoot = Poultice(Ingredient.SpurRoot, 3, 19,
      'Starts regrowth of minor appendage, such as a finger.');
  static const LavenderSeeds = Poultice(Ingredient.LavenderSeeds, 5, 18,
      'Advantage on Dexterity (Stealth) checks for 1 minute.');
  static const RoyalLichen =
      Poultice(Ingredient.RoyalLichen, 5, 20, 'Heals for 2d4 + 2 hit points.');

  static const Rinwort = Poultice(
      Ingredient.Rinwort, 4, 18, 'Reverses total petrification.',
      isSpecial: true);
  static const DriedGinko = Poultice(
      Ingredient.DriedGinkoLeaf, 3, 15, 'Cannot be surprised for 1d4 hours.',
      isSpecial: true);
  static const Hewleaf = Poultice(Ingredient.Hewleaf, 4, 20,
      'Immune to poisoned condition and resistant to poison damage for 1 hour.',
      isSpecial: true);
  static const HyssopDew = Poultice(Ingredient.HyssopDew, 3, 19,
      'Advantage on all sight based Wisdom (Perception) and Intelligence (Investigation) checks for 1d4 hours.',
      isSpecial: true);
  static const Lilythistle = Poultice(
      Ingredient.Lilythistle, 4, 18, 'Do not need air for 1 hour.',
      isSpecial: true);
  static const SilverThornberry = Poultice(
      Ingredient.SilverThornberry, 5, 20, 'Heals for 4d4 + 4 hit points.',
      isSpecial: true);
}
