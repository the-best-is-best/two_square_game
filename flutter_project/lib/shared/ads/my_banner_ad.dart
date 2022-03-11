import 'dart:developer';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../const/device_is_tablet.dart';

class MyBannerAd {
  static AdWidget? adWidget;
  static final BannerAd myBanner = BannerAd(
    //  adUnitId: 'ca-app-pub-7284367511062855/6312687941',
    adUnitId: 'ca-app-pub-7284367511062855/6312687941',

    size: DeviceIsTablet.isTablet() ? AdSize.leaderboard : AdSize.largeBanner,
    request: const AdRequest(),
    listener: listenToAd(),
  );

  final AdSize adSize = const AdSize(width: 320, height: 60);
  static void checkAdLoaded() async {
    adWidget == null ? myBanner.load() : null;
  }

  static void loadWidget() async {
    adWidget = AdWidget(ad: myBanner);
  }

  Future disposeAd() async {
    await myBanner.dispose();
  }
}

BannerAdListener listenToAd() {
  return BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) {
      log('Ad loaded.');
      MyBannerAd.loadWidget();
    },
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      log('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => log('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => log('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => log('Ad impression.'),
  );
}
