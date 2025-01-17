import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GameInfoDialog extends StatelessWidget {
  const GameInfoDialog({super.key});

  static PageRoute<void> route() {
    return HeroDialogRoute(
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: const GameInfoDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final bodyStyle = AppTextStyles.bodyLarge;
    const highlightColor = Color(0xFF9CECCD);
    final linkStyle = AppTextStyles.bodyLarge.copyWith(
      color: highlightColor,
      decoration: TextDecoration.underline,
      decorationColor: highlightColor,
    );
    return AppDialog(
      border: Border.all(color: Colors.white24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 24),
          Assets.images.gameLogo.image(width: 230),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                Text(
                  'About MonsFinance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: bodyStyle,
                    children: [
                      TextSpan(
                        text: 'https://mons.finance',
                        style: linkStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              () => launchUrlString('https://mons.finance/'),
                      ),
                    ],
                  ),
                ),

                /*   const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: l10n.flutterGames,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrlString(Urls.flutterGames),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: l10n.privacyPolicy,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrlString(Urls.privacyPolicy),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: l10n.termsOfService,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => launchUrlString(Urls.termsOfService),
                  ),
                ), */
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
