import 'package:flame/game.dart';
import 'dart:math' as math;

class ResponsiveLayout {
  final Vector2 screenSize;
  
  ResponsiveLayout(this.screenSize);
  
  bool get isMobile => screenSize.x < 600;
  bool get isTablet => screenSize.x >= 600 && screenSize.x < 1024;
  bool get isDesktop => screenSize.x >= 1024;
  
  double get scaleFactor {
    if (isMobile) return 0.8;
    if (isTablet) return 1.0;
    return 1.2;
  }
  
  /// Distance between track centers - closer on mobile for better playability
  double get trackSeparation {
    if (isMobile) return screenSize.y * 0.08;
    if (isTablet) return screenSize.y * 0.1;
    return screenSize.y * 0.12;
  }
  
  double get topTrackY => screenSize.y * 0.5 - trackSeparation;
  double get bottomTrackY => screenSize.y * 0.5 + trackSeparation;
  
  /// Distance balls float from track centers
  double get ballOffset {
    if (isMobile) return 40;
    if (isTablet) return 50;
    return 60;
  }
  
  double get topTrackCenterY => topTrackY;
  double get bottomTrackCenterY => bottomTrackY;
  
  double get topBallY => topTrackCenterY - ballOffset;
  double get bottomBallY => bottomTrackCenterY + ballOffset;
  
  double get ballRadius {
    if (isMobile) return 16;
    if (isTablet) return 20;
    return 25;
  }
  
  /// Gate dimensions sized for ball passage
  Vector2 get gateSize {
    if (isMobile) return Vector2(35, 60);
    if (isTablet) return Vector2(40, 70);
    return Vector2(45, 80);
  }
  
  double get hudFontSize {
    if (isMobile) return 24;
    if (isTablet) return 28;
    return 32;
  }
  
  Vector2 get hudPanelSize {
    if (isMobile) return Vector2(180, 50);
    if (isTablet) return Vector2(200, 60);
    return Vector2(240, 70);
  }
  
  double get trackHeight {
    if (isMobile) return 8;
    if (isTablet) return 10;
    return 12;
  }
  
  /// Base game speed - slower on mobile for easier control
  double get baseScrollSpeed {
    if (isMobile) return 100;
    if (isTablet) return 120;
    return 150;
  }
  
  /// Gate spawn timing - more time on mobile
  double get spawnInterval {
    if (isMobile) return 3.5;
    if (isTablet) return 3.0;
    return 2.5;
  }
  
  double get uiMargin {
    if (isMobile) return 20;
    if (isTablet) return 30;
    return 40;
  }
  
  Vector2 get hudPosition => Vector2(screenSize.x / 2, uiMargin + hudPanelSize.y / 2);
}
