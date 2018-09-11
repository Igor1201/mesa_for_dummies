import 'dart:math';
import 'package:mesa_for_dummies/main.dart';
import 'package:test/test.dart';

void main() {
  test('we can roll a single die', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('d20'), 16);
  });

  test('we can roll a die multiple times', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('2d20'), 26);
  });

  test('we can roll a die and sum an amount', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('1d20+4'), 20);
  });

  test('we can roll multiple dice', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('d6+d4'), 6);
  });

  test('whitespace between operations work', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('d6       +         d4'), 6);
  });

  test('whitespace between "d" work as well', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('d 20'), 16);
  });

  test('more complex math operations work', () {
    D20 die = D20(random: Random(0));
    expect(die.roll('d20 * 2 + 8 * sin(0) - 10'), 22);
  });
}
