import 'package:shared_preferences/shared_preferences.dart';
import '../core/result.dart';

class WalletService {
  WalletService(this._prefs);
  final SharedPreferences _prefs;
  static const _key = 'hakpay_points';

  int get points => _prefs.getInt(_key) ?? 0;

  Future<Result<int>> addPoints(int amount) async {
    if (amount <= 0) return const Err('Geçersiz puan miktarı');
    final next = points + amount;
    await _prefs.setInt(_key, next);
    return Ok(next);
  }
}
