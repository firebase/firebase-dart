@TestOn('vm')
import 'package:_shared_assets/assets_io.dart';
import 'package:firebase/firebase_io.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

import 'test_util.dart';

void main() {
  late String databaseUri;
  late FirebaseClient fbClient;
  late String testUri;

  setUpAll(() async {
    final token = await getAccessToken(Client());
    fbClient = FirebaseClient(token.data);

    addTearDown(fbClient.close);

    databaseUri = await getDatabaseUri();
  });

  setUp(() {
    final path = validDatePath();
    testUri = '$databaseUri/$path.json';
  });

  tearDown(() async {
    await fbClient.delete(testUri);
  });

  test('never-accessed path is null', () async {
    final response = await fbClient.get(testUri);
    expect(response, isNull);
  });

  test('Uri is fine, too', () async {
    final response = await fbClient.get(Uri.parse(testUri));
    expect(response, isNull);
  });

  test('put', () async {
    var response = await fbClient.put(testUri, 'bob');
    expect(response, 'bob');

    response = await fbClient.get(testUri);
    expect(response, 'bob');
  });

  test('post', () async {
    var response = await fbClient.post(testUri, 'bob') as Map;
    expect(response, contains('name'));

    final key = response['name'];

    response = await fbClient.get(testUri);
    expect(response, {key: 'bob'});
  });

  test('patch', () async {
    var response = await fbClient.patch(testUri, {'someNewKey': 'bob'}) as Map;
    expect(response, contains('someNewKey'));

    const key = 'someNewKey';

    response = await fbClient.get(testUri);
    expect(response, {key: 'bob'});
  });

  test('cleanup', () async {
    final oneMinuteOld = DateTime.now().subtract(const Duration(minutes: 1));

    final rootPath = '$databaseUri/pkg_firebase_test.json';
    final response = await fbClient.get(rootPath) as Map<String, dynamic>?;

    if (response == null) {
      return;
    }
    for (var entry in response.entries) {
      if (entry.key.contains('T')) {
        final oldUri = '$databaseUri/pkg_firebase_test/${entry.key}.json';
        print(oldUri);
        final split = entry.key.split('T');
        final date = DateTime.tryParse(split.first);
        if (date != null && date.isBefore(oneMinuteOld)) {
          await fbClient.delete(oldUri);
        }
      }
    }
  });
}
