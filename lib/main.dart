import 'dart:core';
import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class D20 {
  final Parser parser = Parser();
  final ContextModel context = new ContextModel();
  Random random;
  
  D20({random}) {
    this.random = random == null ? Random() : random;
  }

  int roll(String roll) {
    String newRoll = roll.replaceAll(RegExp(r'\s'), '').toLowerCase().replaceAllMapped(RegExp(r'(\d+)?d\d+'), (Match match) {
      Iterable<int> parts = match.group(0).toString().split('d').map((String part) {
        return part.trim().isEmpty ? 1 : int.parse(part);
      });

      return List<int>
        .filled(parts.elementAt(0), parts.elementAt(1))
        .fold(0, (sum, die) => sum + random.nextInt(die) + 1)
        .toString();
    });

    return parser
      .parse(newRoll)
      .evaluate(EvaluationType.REAL, context)
      .round();
  }
}

void main() {
  D20 d20 = D20();
  print(d20.roll('1d20'));
  print(d20.roll('d6'));
  print(d20.roll('d8+4'));
  print(d20.roll('d8+4+d12'));
  print(d20.roll('d8+4+3d12+2'));
}
