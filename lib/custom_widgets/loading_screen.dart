import 'package:dengue_app/custom_widgets/animations.dart';
import 'package:dengue_app/providers/fluttie_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttie/fluttie.dart';

enum AnimationFile { GlowLoading, MaterialLoading }

class AnimatedLoadingScreen extends StatefulWidget {
  final AnimationFile animationType;

  const AnimatedLoadingScreen(this.animationType);

  @override
  _AnimatedLoadingScreenState createState() => _AnimatedLoadingScreenState();
}

class _AnimatedLoadingScreenState extends State<AnimatedLoadingScreen> {
  FluttieAnimations fluttieAnimations;

  @override
  void dispose() {
    _getCorrectController()?.stopAndReset();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fluttieAnimations = FluttieAnimationsProvider.of(context);
    fluttieAnimations.loadAnimations();
    fluttieAnimations.isReady.listen(_handlePlayAnimation);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FluttieAnimation(
      _getCorrectController(),
      size: Size(width / 2, width / 2),
    );
  }

  FluttieAnimationController _getCorrectController() {
    switch (widget.animationType) {
      case AnimationFile.GlowLoading:
        return fluttieAnimations.glowLoadingAnimation;
      case AnimationFile.MaterialLoading:
        return fluttieAnimations.materialLoadingAnimation;
    }
    return null;
  }

  void _handlePlayAnimation(bool b) {
    if (b) {
      _getCorrectController().start();
    }
  }
}
