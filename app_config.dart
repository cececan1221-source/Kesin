class AppConfig {
  AppConfig._();

  // Google'ın resmi test App ID'si. Geliştirme/deneme için güvenlidir.
  static const testAppId = 'ca-app-pub-3940256099942544~3347511713';

  // Android test reklam birimleri.
  static const testBannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const testInterstitialId = 'ca-app-pub-3940256099942544/1033173712';
  static const testRewardedId = 'ca-app-pub-3940256099942544/5224354917';

  // İleride yetişkin hesap sahibi tarafından verilen gerçek ID'ler
  // GitHub Actions secrets / dart-define ile geçirilebilir.
  static const appId = String.fromEnvironment(
    'ADMOB_APP_ID',
    defaultValue: testAppId,
  );
  static const bannerId = String.fromEnvironment(
    'ADMOB_BANNER_ID',
    defaultValue: testBannerId,
  );
  static const rewardedId = String.fromEnvironment(
    'ADMOB_REWARDED_ID',
    defaultValue: testRewardedId,
  );

  static const pointsPerRewardedAd = 20;
}
