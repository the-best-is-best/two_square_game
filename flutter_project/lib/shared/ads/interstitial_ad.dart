import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyInterstitial {
  static InterstitialAd? _interstitialAd;
  static InterstitialAd? getInterstitialAd() => _interstitialAd;
  static Future init() async {
    await InterstitialAd.load(
      adUnitId: 'ca-app-pub-7284367511062855/7574670867',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          // Keep a reference to the ad so you can show it later.
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  static void listener() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            log('%ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          log('$ad onAdDismissedFullScreenContent.');
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          log('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (InterstitialAd ad) => log('$ad impression occurred.'),
      );
    }
  }

  static void getAd() async {
    await MyInterstitial.init();
    if (_interstitialAd != null) {
      _interstitialAd!.show();
    }
  }
}
