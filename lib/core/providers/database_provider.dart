import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/task_management/domain/models/task_model.dart';
import '../../features/task_management/domain/models/user_model.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> database(DatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open(
    [
      TaskModelSchema,
      UserModelSchema,
    ],
    directory: dir.path,
    inspector: true,
  );

  if (kDebugMode) {
    print('Isar database initialized at: ${dir.path}');
  }

  return isar;
}
