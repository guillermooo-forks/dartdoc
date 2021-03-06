// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dartdoc.bin;

import 'dart:io';

import 'package:args/args.dart';
import 'package:dartdoc/dartdoc.dart';
import 'package:cli_util/cli_util.dart' as cli_util;

/// Analyzes Dart files and generates a representation of included libraries,
/// classes, and members. Uses the current directory to look for libraries.
void main(List<String> arguments) {
  var parser = _createArgsParser();
  var results = parser.parse(arguments);

  if (results['help']) {
    _printUsageAndExit(parser);
  }

  if (results['version']) {
    print('$NAME version: $VERSION');
    exit(0);
  }

  Directory sdkDir = cli_util.getSdkDir(arguments);
  if (sdkDir == null) {
    print("Warning: unable to locate the Dart SDK. Please use the --dart-sdk "
        "command line option or set the DART_SDK environment variable.");
    exit(1);
  }

  bool sdkDocs = false;
  if (results['sdk-docs']) {
    sdkDocs = true;
  }

  var readme = results['readme'];
  if (readme != null && !(new File(readme).existsSync())) {
    print(
        "Warning: invalid path, unable to locate the SDK description file at $readme.");
    exit(1);
  }

  List<String> excludeLibraries =
      results['exclude'] == null ? [] : results['exclude'].split(',');
  String url = results['url'];
  var currentDir = Directory.current;
  var generators = initGenerators(url);
  new DartDoc(currentDir, excludeLibraries, sdkDir, generators, sdkDocs, readme)
    ..generateDocs();
}

/// Print help if we are passed the help option or invalid arguments.
void _printUsageAndExit(ArgParser parser) {
  print(parser.usage);
  print('Usage: dartdoc [OPTIONS]');
  exit(0);
}

ArgParser _createArgsParser() {
  var parser = new ArgParser();
  parser.addOption('exclude',
      help: 'a comma-separated list of library names to ignore');
  parser.addOption('dart-sdk', help: 'the location of the Dart SDK');
  parser.addOption('url',
      help: 'the url where the docs will be hosted (used to generate the sitemap)');
  parser.addFlag('help',
      abbr: 'h', negatable: false, help: 'show command help');
  parser.addFlag('version',
      help: 'Display the version for $NAME', negatable: false);
  parser.addFlag('sdk-docs', help: 'generate docs for the Dart SDK.'
      ' '
      'Use "--dart-sdk" option to specify path to sdk');
  parser.addOption('readme', help: 'path to the SDK description file');
  return parser;
}
