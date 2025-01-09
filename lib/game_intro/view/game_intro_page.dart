import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/widgets/game_intro_buttons.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';

class GameIntroPage extends StatefulWidget {
  const GameIntroPage({super.key});

  @override
  State<GameIntroPage> createState() => _GameIntroPageState();
}

class _GameIntroPageState extends State<GameIntroPage> {
  Map<String, dynamic>? telegramData;

  @override
  void initState() {
    super.initState();
    getTelegramData();
  }

  void getTelegramData() {
    final data = initTelegramWebApp();
    setState(() {
      telegramData = data;
    });
  }

  static Map<String, dynamic>? initTelegramWebApp() {
    try {
      final result = js.context.callMethod('initTelegramWebApp');
      if (result != null) {
        final jsonString =
            js.context['JSON'].callMethod('stringify', [result]) as String;
        print('Telegram Data: $jsonString'); // Hata ayıklama için
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } else {
        print('initTelegramWebApp result is null.');
      }
    } catch (e) {
      print('Error fetching Telegram data: $e');
    }

    // Manuel test için sahte bir veri döndürüyoruz
    return {
      'user': {
        'id': '123456',
        'username': 'test_user',
        'first_name': 'John',
        'last_name': 'Doe',
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    final telegramUsername =
        telegramData?['user']?['username'] ?? 'Guest'; // Varsayılan değer
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Text(telegramData?['user']?['username'].toString() ?? 'boss'),
          Text(telegramData?.toString() ?? 'boss'),
          Expanded(
            child: _IntroPage(
              telegramUsername: telegramUsername.toString(),
            ),
          ),
        ],
      ),
    );
  }
}

class _IntroPage extends StatelessWidget {
  const _IntroPage({required this.telegramUsername});

  final String telegramUsername;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          const Spacer(),
          Assets.images.gameLogo.image(),
          const SizedBox(height: 16),
          Text(
            'Welcome, $telegramUsername',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
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
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
