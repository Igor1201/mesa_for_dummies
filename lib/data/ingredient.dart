class Ingredient {
  final List<int> rolls;
  final String name;
  final String effect;
  final bool isSpecial;

  const Ingredient(this.rolls, this.name, this.effect, {this.isSpecial = false});

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
