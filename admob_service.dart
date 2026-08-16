import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/app_config.dart';

class AdMobService {
  AdMobService._();
  static final instance = AdMobService._();

  bool _initialized = false;
  RewardedAd? _rewardedAd;
  bool _loadingRewarded = false;

  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    _loadRewarded();
  }

  void _loadRewarded() {
    if (_loadingRewarded || _rewardedAd != null) return;
    _loadingRewarded = true;
    RewardedAd.load(
      adUnitId: AppConfig.rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _loadingRewarded = false;
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _loadingRewarded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<bool> showRewarded() async {
    final ad = _rewardedAd;
    if (ad == null) {
      _loadRewarded();
      return false;
    }

    _rewardedAd = null;
    final completer = Completer<bool>();
    var earned = false;

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(earned);
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadRewarded();
        if (!completer.isCompleted) completer.complete(false);
      },
    );

    ad.show(
      onUserEarnedReward: (_, __) {
        earned = true;
      },
    );

    return completer.future.timeout(
      const Duration(minutes: 2),
      onTimeout: () => false,
    );
  }

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
  }
}
