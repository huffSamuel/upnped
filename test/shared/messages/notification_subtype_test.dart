import 'package:test/test.dart';
import 'package:upnped/src/shared/messages.dart';

void main() {
  group('NotificationSubtype', () {
    const cases = [
      (null, NotificationSubtype.none),
      ('1', NotificationSubtype.unknown),
      ('ssdp:alive', NotificationSubtype.alive),
      ('ssdp:byebye', NotificationSubtype.byebye),
      ('ssdp:update', NotificationSubtype.update),
    ];

    for (final c in cases) {
      test('when input is ${c.$1}, expect ${c.$2}', () {
        final actual = NotificationSubtype.parse(c.$1);

        expect(actual, equals(c.$2));
      });
    }
  });
}
