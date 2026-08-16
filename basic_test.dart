import 'package:flutter_test/flutter_test.dart';
import 'package:hakpay/config/app_config.dart';

void main() {
  test('AdMob test IDs are present', () {
    expect(AppConfig.testAppId, startsWith('ca-app-pub-'));
    expect(AppConfig.testRewardedId, contains('/'));
    expect(AppConfig.testBannerId, contains('/'));
    expect(AppConfig.pointsPerRewardedAd, 20);
  });
}
