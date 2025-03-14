import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:prokit_flutter/main/component/SettingScreenComponents.dart';
import 'package:prokit_flutter/main/screens/AboutUsScreen.dart';
import 'package:prokit_flutter/main/screens/LanguageSelectionScreen.dart';
import 'package:prokit_flutter/main/utils/AppColors.dart';
import 'package:prokit_flutter/main/utils/AppConstant.dart';
import 'package:prokit_flutter/main/utils/AppWidget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../fullApps/carea/commons/constants.dart';
import '../../main.dart';
import '../../workingApps/chatGPT/utils/constant.dart';

class SettingScreen extends StatefulWidget {
  static String tag = '/SettingScreen';

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  InterstitialAd? interstitialAd;
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (isMobile) {
      _createInterstitialAd();

      myBanner = loadBannerAd()..load();
    }
  }

  BannerAd loadBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId()!,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (ad) {
        //
      }),
    );
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: getInterstitialAdUnitId(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('$ad loaded');
          interstitialAd = ad;
          interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error.');
          interstitialAd = null;
          _createInterstitialAd();
        },
      ),
      request: AdRequest(),
    );
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() async {
    super.dispose();

    if (!getBoolAsync(IN_APP_STORE_REVIEW)) {
      _showInterstitialAd();
    }

    interstitialAd?.dispose();

    myBanner?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        appBar: appBar(
          context,
          language!.lblSettings,
        ),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  16.height,
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/app/ic_theme.png', color: appColorPrimary, height: 40),
                            Text(language!.lblDarkMode, style: boldTextStyle(size: 16)),
                            Switch(
                              value: appStore.isDarkModeOn,
                              trackOutlineColor: MaterialStatePropertyAll(appColorPrimary),
                              thumbColor: MaterialStatePropertyAll(appColorPrimary),
                              onChanged: (s) {
                                appStore.toggleDarkMode(value: s);
                              },
                              activeColor: appColorPrimary,
                            ).scale(scale: 0.85),
                          ],
                        ),
                      ).onTap(() {
                        appStore.toggleDarkMode(value: !appStore.isDarkModeOn);
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/app/ic_documentation.png', height: 30, width: 30, color: appColorPrimary),
                            8.height,
                            Text(language!.lblDocumentation, style: boldTextStyle(size: 16)),
                            8.height,
                            Text(language!.lblSetupConfiguration, style: secondaryTextStyle(size: 12))
                          ],
                        ),
                      ).onTap(() {
                        launch(DocumentationUrl, forceWebView: true, enableJavaScript: true);
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/app/ic_change_log.png', height: 30, width: 30, color: appColorPrimary),
                            8.height,
                            Text(language!.lblChangeLog, style: boldTextStyle(size: 16)),
                            8.height,
                            Text(language!.lblVersionHistory, style: secondaryTextStyle(size: 12))
                          ],
                        ),
                      ).onTap(() {
                        launch(ChangeLogsUrl, forceWebView: true, enableJavaScript: true);
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/app/ic_share.png', height: 30, width: 30, color: appColorPrimary),
                            8.height,
                            Text(language!.lblShareApp, style: boldTextStyle(size: 16)),
                            8.height,
                            Text(language!.lblShareWithFriends, style: secondaryTextStyle(size: 12))
                          ],
                        ),
                      ).onTap(() async {
                        getPackageInfo().then((value) async {
                          String package = value.packageName.validate();
                          if (isIOS)
                            await Share.share('Download $mainAppName from AppStore\n\n\n$AppstoreUrl');
                          else
                            await Share.share('Download $mainAppName from Play Store\n\n\n$PlayStoreUrl$package');
                        });
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('images/app/ic_rate_app.png', height: 30, width: 30, color: appColorPrimary),
                            8.height,
                            Text(language!.lblRateUs, style: boldTextStyle(size: 16)),
                            8.height,
                            Text(language!.lblRateGooglePlayStore, style: secondaryTextStyle(size: 12))
                          ],
                        ),
                      ).onTap(() {
                        getPackageInfo().then((value) async {
                          String package = value.packageName.validate();
                          if (isIOS) launchUrl(Uri.parse("$AppstoreUrl"), mode: LaunchMode.externalApplication);
                          launchUrl(Uri.parse("$PlayStoreUrl$package"), mode: LaunchMode.externalApplication);
                        });
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(MaterialCommunityIcons.google_translate, color: appColorPrimary, size: 30),
                            8.height,
                            Text(language!.lblLanguage, style: boldTextStyle(size: 16)),
                            8.height,
                            Text(language!.lblSupportLanguage, style: secondaryTextStyle(size: 12))
                          ],
                        ),
                      ).onTap(() async {
                        LanguageSelectionScreen().launch(context).then((value) => setState(() {}));
                      }, borderRadius: radius(defaultRadius)),
                      SettingContainerWidget(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset('images/app/app_ic_phone.svg', color: appColorPrimary, height: 30),
                          8.height,
                          Text(language!.lblContactUs, style: boldTextStyle(size: 16)),
                          8.height,
                          Text(language!.lblGetInTouchWithUs, style: secondaryTextStyle(size: 12)),
                        ],
                      )).onTap(() {
                        contactBottomSheet(context);
                      }, borderRadius: radius(defaultRadius)),
                      SnapHelperWidget<PackageInfoData>(
                        future: getPackageInfo(),
                        onSuccess: (data) => SettingContainerWidget(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline, color: appColorPrimary, size: 30),
                              8.height,
                              Text(language!.lblAboutUs, style: boldTextStyle(size: 16)),
                              8.height,
                              if (!kIsWeb)
                                Row(
                                  children: [
                                    Text('${language!.lblVersion} ${data.versionName}', style: secondaryTextStyle(size: 12)),
                                  ],
                                ),
                            ],
                          ),
                        ).onTap(() {
                          AboutUsScreen().launch(context);
                        }, borderRadius: radius(defaultRadius)),
                      ),
                      /* OpenContainer(
                        closedBuilder: (_, openContainer) {
                          return Container(
                            height: 80,
                            width: 80,
                            child: Center(
                              child: Text(
                                'App Logo',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                        openColor: Colors.white,
                        closedElevation: 20,
                        closedShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        transitionDuration: Duration(milliseconds: 700),
                        openBuilder: (_, closeContainer) {
                          return SecondClass();
                        },
                      ),*/
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ],
              ),
            ),
            if (myBanner != null)
              Positioned(
                child: AdWidget(ad: myBanner!),
                bottom: 0,
                height: myBanner!.size.height.toDouble(),
                width: myBanner!.size.width.toDouble(),
              ).visible(!getBoolAsync(IN_APP_STORE_REVIEW)),
          ],
        ),
      ),
    );
  }
}
