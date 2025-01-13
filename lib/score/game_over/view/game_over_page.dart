import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/game_intro/game_intro.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/score/score.dart';
import 'package:http/http.dart' as http;
import 'dart:js' as js;

class GameOverPage extends StatelessWidget {
  const GameOverPage({super.key});

  static Page<void> page() {
    return const MaterialPage(
      child: GameOverPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    const titleColor = Color(0xFFFFFFFF);
    final score = context.select((ScoreBloc bloc) => bloc.score);

    return PageWithBackground(
      background: const GameBackground(),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AspectRatio(
          aspectRatio: .56,
          child: Column(
            children: [
              const Spacer(flex: 15),
              Text(
                l10n.gameOver,
                style: textTheme.headlineMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.betterLuckNextTime,
                style: textTheme.bodyLarge?.copyWith(
                  color: titleColor,
                ),
              ),
              const Spacer(flex: 4),
              Text(
                l10n.totalScore,
                style: textTheme.bodyLarge?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(flex: 2),
              _ScoreWidget(score),
              const Spacer(flex: 10),
              if (kIsWeb) const WebButtons() else const MobileButtons(),
              const Spacer(flex: 30),
              const BottomBar(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatefulWidget {
  final int score;
  const _ScoreWidget(this.score);

  @override
  State<_ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<_ScoreWidget> {
  Map<String, dynamic>? telegramData;

  @override
  void initState() {
    getTelegramData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final score = context.select((ScoreBloc bloc) => bloc.score);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0x80EAFFFE),
            Color(0x80C9D9F1),
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.trophy.image(width: 40, height: 40),
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              style: textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(text: '${formatScore(score)} '),
                TextSpan(
                  text: l10n.pts,
                  style: const TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatScore(int score) {
    final formatter = NumberFormat('#,###');
    return formatter.format(score);
  }

  Future<void> sendScore(Map<String, dynamic> data) async {
    try {
      final telegramId = data['user']['id'].toString();

      final url = Uri.parse(
          'https://mini-backend.devargedor.com/api/Customer/CustomerGamePointsLogMons?gamePoint=${widget.score}&customerTelegramId=$telegramId');

      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        print('API isteği başarılı: ${response.body}');
      } else {
        print(
            'API isteği başarısız: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('API isteği sırasında hata oluştu: $e');
    }
  }

  void getTelegramData() {
    final data = initTelegramWebApp();
    setState(() {
      telegramData = data;
    });
    sendScore(telegramData!);
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
        'id': '',
        'username': '',
        'first_name': '',
        'last_name': '',
      }
    };
  }
}
