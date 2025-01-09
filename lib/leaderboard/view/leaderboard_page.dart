import 'dart:convert';

import 'package:app_ui/app_ui.dart';
import 'package:flame/cache.dart';
import 'package:flame/image_composition.dart';
import 'package:flame/widgets.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';
import 'package:super_dash/game/game.dart';
import 'package:super_dash/gen/assets.gen.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/leaderboard/bloc/leaderboard_bloc.dart';
import 'package:super_dash/score/score.dart';
import 'package:http/http.dart' as http;

enum LeaderboardStep { gameIntro, gameScore }

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({
    this.step = LeaderboardStep.gameIntro,
    super.key,
  });

  static Page<void> page([
    LeaderboardStep step = LeaderboardStep.gameScore,
  ]) {
    return MaterialPage(
      child: LeaderboardPage(step: step),
    );
  }

  static PageRoute<void> route([
    LeaderboardStep step = LeaderboardStep.gameIntro,
  ]) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => LeaderboardPage(step: step),
    );
  }

  final LeaderboardStep step;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaderboardBloc(
        leaderboardRepository: context.read<LeaderboardRepository>(),
      )..add(const LeaderboardTop10Requested()),
      child: LeaderboardView(step: step),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({
    required this.step,
    super.key,
  });

  final LeaderboardStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PageWithBackground(
      background: const GameBackground(),
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.images.leaderboardBg.provider(),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .15,
            ),
            const Leaderboard(),
            const SizedBox(height: 20),
            Align(
              child: switch (step) {
                LeaderboardStep.gameIntro => GameElevatedButton(
                    label: l10n.leaderboardPageGoBackButton,
                    onPressed: Navigator.of(context).pop,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFA6C3DF),
                        Color(0xFF79AACA),
                      ],
                    ),
                  ),
                LeaderboardStep.gameScore => GameElevatedButton.icon(
                    label: l10n.playAgain,
                    icon: const Icon(Icons.refresh, size: 32),
                    onPressed: context.flow<ScoreState>().complete,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Leaderboard extends StatelessWidget {
  const Leaderboard({super.key});

  static const width = 360.0;
  static const height = 420.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4E4F65),
            Color(0xFF1B1B36),
          ],
        ),
      ),
      child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) => switch (state) {
          LeaderboardInitial() => const SizedBox.shrink(),
          LeaderboardLoading() =>
            const Center(child: LeaderboardLoadingWidget()),
          LeaderboardError() => const Center(child: LeaderboardErrorWidget()),
          LeaderboardLoaded(entries: final entries) => LeaderboardContent(),
        },
      ),
    );
  }
}

@visibleForTesting
class LeaderboardErrorWidget extends StatelessWidget {
  const LeaderboardErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 64,
          child: SpriteAnimationWidget.asset(
            images: Images(prefix: ''),
            path: Assets.map.anim.spritesheetDashDeathFaintPng.path,
            data: SpriteAnimationData.sequenced(
              amount: 16,
              stepTime: 0.042,
              textureSize: Vector2.all(64), // Game's tile size.
              amountPerRow: 8,
              loop: false,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(context.l10n.leaderboardPageLeaderboardErrorText),
      ],
    );
  }
}

@visibleForTesting
class LeaderboardLoadingWidget extends StatelessWidget {
  const LeaderboardLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator();
  }
}

@visibleForTesting
class LeaderboardContent extends StatefulWidget {
  const LeaderboardContent({
    super.key,
  });

  @override
  State<LeaderboardContent> createState() => _LeaderboardContentState();
}

class _LeaderboardContentState extends State<LeaderboardContent> {
  List<dynamic>? leaderBoardList;
  @override
  void initState() {
    fetchLeaderboard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.leaderboardPageLeaderboardHeadline,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) =>
                      const Divider(color: Colors.grey),
                  itemCount: leaderBoardList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      minVerticalPadding: 0,
                      contentPadding: EdgeInsets.zero,
                      leading: Text('#${index + 1}'),
                      title: Text(
                          leaderBoardList?[index]['userName'].toString() ??
                              'NULL'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if ([0, 1, 2].contains(index)) ...[
                            Icon(
                              FontAwesomeIcons.trophy,
                              size: 20,
                              color: switch (index) {
                                0 => const Color(0xFFD4AF37),
                                1 => const Color(0xFFC0C0C0),
                                _ => const Color(0xFFCD7F32),
                              },
                            ),
                            const SizedBox(width: 10),
                          ],
                          Text(l10n.gameScoreLabel(
                              leaderBoardList?[index]['totalPoints'] as int)),
                        ],
                      ),
                      titleTextStyle: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      leadingAndTrailingTextStyle:
                          textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            width: Leaderboard.width,
            height: Leaderboard.height * .2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.8],
                colors: [
                  Colors.transparent,
                  Color(0xFF1B1B36),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<List<LeaderboardEntryDataNew>> fetchLeaderboard() async {
    final response = await http.get(
      Uri.parse(
          'https://mini-backend.devargedor.com/api/Score/GetLeaderboardMonsGameWithData'),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List<dynamic> data = body['data'] as List<dynamic>;
      setState(() {
        leaderBoardList = data;
      });
      return data
          .map((entry) =>
              LeaderboardEntryDataNew.fromJson(entry as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}

class LeaderboardEntryDataNew {
  final String userName;
  final int totalPoints;

  LeaderboardEntryDataNew({required this.userName, required this.totalPoints});

  factory LeaderboardEntryDataNew.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntryDataNew(
      userName: json['userName'] as String ?? 'Unknown',
      totalPoints: json['totalPoints'] as int ?? 0,
    );
  }
}
