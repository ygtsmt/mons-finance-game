import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_behaviors/flame_behaviors.dart';
import 'package:super_dash/game/game.dart';

enum DashState {
  idle,
  running,

  phoenixIdle,
  phoenixRunning,

  deathPit,
  deathFaint,

  jump,
  phoenixJump,

  phoenixDoubleJump,
}

class PlayerStateBehavior extends Behavior<Player> {
  DashState? _state;

  late final Map<DashState, PositionComponent> _stateMap;

  DashState get state => _state ?? DashState.idle;

  static const _needResetStates = {
    DashState.deathPit,
    DashState.deathFaint,
    DashState.jump,
    DashState.phoenixJump,
    DashState.phoenixDoubleJump,
  };

  void updateSpritePaintColor(Color color) {
    for (final component in _stateMap.values) {
      if (component is HasPaint) {
        (component as HasPaint).paint.color = color;
      }
    }
  }

  void fadeOut({VoidCallback? onComplete}) {
    final component = _stateMap[state];
    if (component != null && component is HasPaint) {
      component.add(
        OpacityEffect.fadeOut(
          EffectController(duration: .5),
          onComplete: onComplete,
        ),
      );
    }
  }

  void fadeIn({VoidCallback? onComplete}) {
    final component = _stateMap[state];
    if (component != null && component is HasPaint) {
      component.add(
        OpacityEffect.fadeIn(
          EffectController(duration: .5, startDelay: .8),
          onComplete: onComplete,
        ),
      );
    }
  }

  set state(DashState state) {
    if (state != _state) {
      final current = _stateMap[_state];

      if (current != null) {
        current.removeFromParent();

        if (_needResetStates.contains(_state)) {
          if (current is SpriteAnimationComponent) {
            current.animationTicker?.reset();
          }
        }
      }

      final replacement = _stateMap[state];
      if (replacement != null) {
        parent.add(replacement);
      }
      _state = state;
    }
  }

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();

    final [
      idleAnimation,
      runningAnimation,
      phoenixIdleAnimation,
      phoenixRunningAnimation,
      deathPitAnimation,
      deathFaintAnimation,
      jumpAnimation,
      phoenixJumpAnimation,
      phoenixDoubleJumpAnimation,
    ] = await Future.wait(
      [
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 1,
            stepTime: 999999,
            textureSize: Vector2.all(90),
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 999999,
            textureSize: Vector2.all(90),
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 18,
            stepTime: 999999,
            textureSize: Vector2.all(90),
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 999999,
            textureSize: Vector2.all(90),
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction_death.png',
          SpriteAnimationData.sequenced(
            amount: 24,
            stepTime: 999999,
            textureSize: Vector2.all(90),
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction_death.png',
          SpriteAnimationData.sequenced(
            amount: 24,
            stepTime: 999999,
            textureSize: Vector2.all(90),
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 99999,
            textureSize: Vector2.all(90),
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 99999,
            textureSize: Vector2.all(90),
            amountPerRow: 8,
            loop: false,
          ),
        ),
        parent.gameRef.loadSpriteAnimation(
          'anim/auto_run_instruction.png',
          SpriteAnimationData.sequenced(
            amount: 16,
            stepTime: 99999,
            textureSize: Vector2.all(90),
            loop: false,
          ),
        ),
      ],
    );

    final paint = Paint()..isAntiAlias = false;

    final centerPosition = parent.size / 2 - Vector2(0, parent.size.y / 2);
    _stateMap = {
      DashState.idle: SpriteAnimationComponent(
        animation: idleAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.running: SpriteAnimationComponent(
        animation: runningAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.phoenixIdle: SpriteAnimationComponent(
        animation: phoenixIdleAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.phoenixRunning: SpriteAnimationComponent(
        animation: phoenixRunningAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.deathPit: SpriteAnimationComponent(
        animation: deathPitAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.deathFaint: SpriteAnimationComponent(
        animation: deathFaintAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.jump: SpriteAnimationComponent(
        animation: jumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.phoenixJump: SpriteAnimationComponent(
        animation: phoenixJumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
      DashState.phoenixDoubleJump: SpriteAnimationComponent(
        animation: phoenixDoubleJumpAnimation,
        anchor: Anchor.center,
        position: centerPosition.clone(),
        paint: paint,
      ),
    };

    state = DashState.idle;
  }
}
