import 'dart:convert';
import 'dart:js' as js;
import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:super_dash/constants/constants.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';

class GameIntroPage extends StatefulWidget {
  const GameIntroPage({super.key});

  @override
  State<GameIntroPage> createState() => _GameIntroPageState();
}

class _GameIntroPageState extends State<GameIntroPage> {
  String? telegramUserName;
  dynamic deneme;
  dynamic deneme2;

  @override
  void initState() {
    super.initState();
    fetchTelegramUserName();
  }

  // Kullanıcı adını Telegram SDK üzerinden çekme
  void fetchTelegramUserName() {
    try {
      final initData =
          js.context.callMethod('eval', ['Telegram.WebApp.initData']);
      final initDataJson = js.context.callMethod('JSON.parse', [initData]);

      setState(() {
        deneme2 = initData;
        telegramUserName =
            (initDataJson['user']?['username'] as String?) ?? 'Guest';
        deneme = initDataJson;
      });

      print(initData.toString());
    } catch (e) {
      print(e.toString());
      // Hata durumunda varsayılan bir değer
      setState(() {
        telegramUserName = 'Guest';
      });
      debugPrint('Telegram username fetch error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text(deneme2.toString() ?? ' ssss'),
          Text(deneme.toString() ?? ' skafkjs'),
          Text(telegramUserName ?? ' skafkjs'),
          Expanded(child: _IntroPage()),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        children: [
          const Spacer(),
          Assets.images.gameLogo.image(),
          /*  const Spacer(flex: 3),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.gameIntroPageHeadline,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ), */
          const SizedBox(height: 32),
          GameElevatedButton(
            label: l10n.gameIntroPagePlayButtonText,
            onPressed: () => Navigator.of(context).push(Game.route()),
          ),
          const Spacer(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AudioButton(),
              LeaderboardButton(),
              InfoButton(),
              // HowToPlayButton(),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _MobileWebNotAvailableIntroPage extends StatelessWidget {
  const _MobileWebNotAvailableIntroPage({
    required this.onDownload,
  });

  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const Spacer(),
            Assets.images.gameLogo.image(width: 282),
            const Spacer(flex: 4),
            const SizedBox(height: 24),
            Text(
              l10n.downloadAppMessage,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            GameElevatedButton.icon(
              label: l10n.downloadAppLabel,
              icon: const Icon(
                Icons.download,
                color: Colors.white,
                size: 32,
              ),
              onPressed: onDownload,
            ),
            const Spacer(),
            const BottomBar(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
