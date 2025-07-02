import 'package:flutter_test/flutter_test.dart';

import 'calculator.dart';

void main() {
  test('adds one to input values', () {
    final c = Calculator();
    expect(c.addOne(2), 3);
    expect(c.addOne(-7), -6);
    expect(c.addOne(0), 1);
  });
}
