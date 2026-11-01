import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain Layer Purity Architecture Tests', () {
    test(
      'lib/domain/ contains zero framework, platform, database, or UI imports',
      () {
        final domainDir = Directory('lib/domain');
        expect(domainDir.existsSync(), isTrue, reason: 'lib/domain must exist');

        final prohibitedPatterns = [
          'package:flutter/',
          'package:drift/',
          'package:sqlite',
          'package:path/',
          'package:path_provider/',
          'package:http/',
          'dart:io',
          'dart:html',
          'dart:ui',
        ];

        final dartFiles = domainDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((f) => f.path.endsWith('.dart'));

        expect(
          dartFiles,
          isNotEmpty,
          reason: 'Domain directory should have dart files',
        );

        for (final file in dartFiles) {
          final lines = file.readAsLinesSync();
          for (var i = 0; i < lines.length; i++) {
            final line = lines[i].trim();
            if (line.startsWith('import ') || line.startsWith('export ')) {
              for (final prohibited in prohibitedPatterns) {
                expect(
                  line.contains(prohibited),
                  isFalse,
                  reason:
                      'File ${file.path}:${i + 1} contains prohibited import "$prohibited". Domain layer must remain 100% pure Dart.',
                );
              }
            }
          }
        }
      },
    );
  });
}
