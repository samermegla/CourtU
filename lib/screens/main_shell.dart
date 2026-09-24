import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import 'map_screen.dart';
import 'scorekeeper_screen.dart';
import 'social_screen.dart';

/// The persistent shell for the signed-in app: three tabs under a fixed bottom
/// bar. The AuthGate lands here instead of straight on the map.
///
/// The children are held in an [IndexedStack] rather than swapped with a
/// `switch`, so the Mapbox widget is never disposed when you leave the map tab.
/// Rebuilding it would re-download tiles and reset the camera.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  // Map is the middle tab and where the app lands.
  int _index = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _index,
        children: const [
          ScorekeeperScreen(),
          MapScreen(),
          SocialScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        index: _index,
        onTap: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onTap;

  const _BottomNavBar({required this.index, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      // top: false so only the home-indicator inset is honoured.
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 46.h,
          child: Row(
            children: [
              _NavItem(
                emoji: '📋',
                selected: index == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                emoji: '🗺️',
                selected: index == 1,
                onTap: () => onTap(1),
              ),
              _NavItem(
                emoji: '👤',
                selected: index == 2,
                onTap: () => onTap(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One tab. Emoji glyphs ignore [TextStyle.color], so with the labels gone the
/// selected state is carried entirely by opacity plus the indicator above.
class _NavItem extends StatelessWidget {
  final String emoji;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.emoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 22.w,
              height: 3.h,
              margin: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                color: selected ? AppColors.steelLight : Colors.transparent,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Opacity(
              opacity: selected ? 1 : 0.45,
              child: Text(emoji, style: TextStyle(fontSize: 22.sp)),
            ),
          ],
        ),
      ),
    );
  }
}
