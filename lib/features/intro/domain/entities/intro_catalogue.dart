import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_strings.dart';
import 'intro_slide.dart';

abstract final class IntroCatalogue {
  static const List<IntroSlide> slides = <IntroSlide>[
    IntroSlide(
      overline: AppStrings.introAssistantOverline,
      title: AppStrings.introAssistantTitle,
      body: AppStrings.introAssistantBody,
      illustration: AppAssets.introAsk,
    ),
    IntroSlide(
      overline: AppStrings.introDailyOverline,
      title: AppStrings.introDailyTitle,
      body: AppStrings.introDailyBody,
      illustration: AppAssets.introDaily,
    ),
    IntroSlide(
      overline: AppStrings.introDocumentsOverline,
      title: AppStrings.introDocumentsTitle,
      body: AppStrings.introDocumentsBody,
      illustration: AppAssets.introDocuments,
    ),
  ];
}
