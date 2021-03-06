// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.io_utils_test;

import 'dart:io';

import 'package:unittest/unittest.dart';

import 'package:dartdoc/src/io_utils.dart';

void main() {
  group('io utils', () {
    test('find files to document', () {
      var files = findFilesToDocumentInPackage(Directory.current.path);
      expect(files.length, 2);
    });

    test('check file name', () {
      var fileName = getFileNameFor('dart:io');
      expect(fileName, 'dart_io.html');
      fileName = getFileNameFor('dartdoc.generator');
      expect(fileName, 'dartdoc_generator.html');
    });
  });
}
