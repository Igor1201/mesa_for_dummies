import 'd20.dart';

void main() {
  D20 d20 = D20();
  print(d20.roll('1d20'));
  print(d20.roll('d6'));
  print(d20.roll('d8+4'));
  print(d20.roll('d8+4+d12'));
  print(d20.roll('d8+4+3d12+2'));
}
