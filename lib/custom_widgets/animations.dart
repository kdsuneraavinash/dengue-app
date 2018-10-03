import 'dart:async';

import 'package:fluttie/fluttie.dart';
import 'package:rxdart/rxdart.dart';

class FluttieAnimations {
  final Fluttie _fluttieInstance = Fluttie();

  int _glowLoadingComposition;
  FluttieAnimationController glowLoadingAnimation;

  int _materialLoadingComposition;
  FluttieAnimationController materialLoadingAnimation;

  BehaviorSubject<bool> _isReady = BehaviorSubject(seedValue: false);
  Stream<bool> get isReady => _isReady.stream;

  FluttieAnimations() {
    loadAnimations();
  }

  Future<void> loadAnimations() async {
    _glowLoadingComposition = await _fluttieInstance
        .loadAnimationFromAsset("assets/animations/glow_loading.json");
    _materialLoadingComposition = await _fluttieInstance
        .loadAnimationFromAsset("assets/animations/material_loading.json");

    glowLoadingAnimation = await _prepareLoopingAnimation(_glowLoadingComposition);
    materialLoadingAnimation =
        await _prepareLoopingAnimation(_materialLoadingComposition);

    _isReady.add(true);
  }

  Future<FluttieAnimationController> _prepareLoopingAnimation(
      int composition) async {
    return _fluttieInstance.prepareAnimation(composition,
        repeatCount: const RepeatCount.infinite(),
        repeatMode: RepeatMode.START_OVER);
  }

  void dispose() {
    _isReady.close();
  }
}
