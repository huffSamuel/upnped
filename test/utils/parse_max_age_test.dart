import 'package:test/test.dart';
import 'package:upnped/src/utils/parse_max_age.dart';

void main() {
  group('parseMaxAge', () {
    const cases = [
      ('max-age=10', Duration(seconds: 10)),
      (null, null),
      ('foo', null),
      ('max-age=10, must-revalidate', Duration(seconds: 10)),
      ('max-age=10, max-age=20', Duration(seconds: 20))
    ];

    for(final c in cases) {
      test('when input is ${c.$1} expect ${c.$2}', () {
        final actual = parseMaxAge(c.$1);

        expect(actual, equals(c.$2));
      });
    }
  });
}