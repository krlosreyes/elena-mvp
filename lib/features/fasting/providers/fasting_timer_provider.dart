import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fastingTimerProvider =
    StreamProvider<Duration>((ref) async* {
  yield* Stream.periodic(
    const Duration(seconds: 1),
    (_) => const Duration(seconds: 1),
  );
});
