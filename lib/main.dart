import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/app.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}
