import 'package:app_ui/app_ui.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:super_dash/l10n/l10n.dart';
import 'package:super_dash/score/score.dart';
import 'package:super_dash/share/share.dart';

const _gradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFFA6C3DF),
    Color(0xFF79AACA),
  ],
);

class WebButtons extends StatelessWidget {
  const WebButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.shareOn),
            const SizedBox(width: 16),
            _ShareButton(
              icon: const Icon(
                FontAwesomeIcons.xTwitter,
                size: 20,
                color: Colors.white,
              ),
              onPressed: () {
                final score = context.read<ScoreBloc>().score;
                context.read<ShareController>().shareOnTwitter(score);
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(width: 16),
        const SizedBox(height: 24),
        const SeeTheRankingButton(),
        const SizedBox(height: 24),
        const _PlayAgainButton(),
      ],
    );
  }
}

class MobileButtons extends StatelessWidget {
  const MobileButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      children: [
        GameElevatedButton.icon(
          icon: const Icon(
            Icons.share,
            size: 32,
          ),
          label: l10n.share,
          gradient: _gradient,
          onPressed: () {
            final score = context.read<ScoreBloc>().score;
            context.read<ShareController>().shareMobile(score);
          },
        ),
        const SizedBox(height: 24),
        const _PlayAgainButton(),
        const SizedBox(height: 24),
        const SeeTheRankingButton(),
      ],
    );
  }
}

class _ShareButton extends StatelessWidget {
  const _ShareButton({
    required this.icon,
    required this.onPressed,
  });

  final Icon icon;

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(94);
    return Container(
      height: 52,
      width: 52,
      decoration: BoxDecoration(
        gradient: _gradient,
        border: Border.all(color: Colors.white24),
        borderRadius: borderRadius,
      ),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onPressed,
        child: icon,
      ),
    );
  }
}

class _PlayAgainButton extends StatelessWidget {
  const _PlayAgainButton();
/*   GameElevatedButton.icon(
                label: l10n.playAgain,
                icon: const Icon(Icons.refresh, size: 32),
                onPressed: context.flow<ScoreState>().complete,
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFA6C3DF),
                    Color(0xFF79AACA),
                  ],
                ),
              ), */
  @override
  Widget build(BuildContext context) {
    return GameElevatedButton.icon(
      icon: const Icon(Icons.refresh, size: 32),
      label: context.l10n.playAgain,
      gradient: _gradient,
      onPressed: context.flow<ScoreState>().complete,
    );
  }
}

class SeeTheRankingButton extends StatelessWidget {
  const SeeTheRankingButton();

  @override
  Widget build(BuildContext context) {
    return GameElevatedButton(
      label: context.l10n.seeTheRanking,
      onPressed: () {
        context.read<ScoreBloc>().add(const ScoreLeaderboardRequested());
      },
    );
  }
}
