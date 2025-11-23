import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/fasting_repository.dart';
import '../data/models/fasting_model.dart';

/// Repository Provider
final fastingRepositoryProvider = Provider<FastingRepository>((ref) {
  return FastingRepository();
});

/// Estado reactivo completo
class FastingNotifier extends StateNotifier<AsyncValue<FastingSession?>> {
  final Ref ref;

  FastingNotifier(this.ref) : super(const AsyncValue.data(null)) {
    _loadActive();
  }

  Future<void> _loadActive() async {
    final repo = ref.read(fastingRepositoryProvider);
    final s = await repo.getActiveSession();
    state = AsyncValue.data(s);
  }

  Future<void> iniciarAyuno() async {
    try {
      final repo = ref.read(fastingRepositoryProvider);

      final active = await repo.getActiveSession();
      if (active != null) {
        state = AsyncValue.data(active);
        return;
      }

      final session = await repo.startFasting();
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> terminarAyuno() async {
    try {
      final repo = ref.read(fastingRepositoryProvider);

      final session = await repo.getActiveSession();
      if (session == null) {
        state = const AsyncValue.data(null);
        return;
      }

      await repo.endFasting(session.id);
      await repo.updateStreaks();

      final updated = await repo.getActiveSession(); // será null
      state = AsyncValue.data(updated);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final fastingNotifierProvider =
    StateNotifierProvider<FastingNotifier, AsyncValue<FastingSession?>>((ref) {
  return FastingNotifier(ref);
});
