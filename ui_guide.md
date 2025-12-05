# UI Design Guide for Mobile Applications (2025)

*A comprehensive guide for Flutter developers combining Material Design 3, modern interaction patterns, and accessibility best practices.*

---

## Executive Summary

This guide defines the standard for modern mobile UI in 2025. Focus areas:
- **Material Design 3 Expressive** with dynamic color (Android 12+)
- **Glanceable-first** home screens with adaptive grid layouts
- **Gesture-based navigation** with haptic feedback microinteractions
- **WCAG 2.2 accessibility** with semantic components
- **Responsive design** for phones, tablets, and foldables
- **Dark mode** as standard, not option
- **Smooth animations** (120–200 ms) with purpose

---

## 0) Fast Goals

1. Enable **Material 3 Expressive + dynamic color** on Android 12+
2. Design **glanceable feeds** (users understand value in 1–2 seconds)
3. Implement **gesture-based navigation** with tactile feedback
4. Comply with **WCAG 2.2** accessibility standards
5. Support **dark mode** and **adaptive layouts** (responsive + foldable)
6. Use **purposeful microinteractions** (120–200 ms animations + haptics)
7. Ensure **thumb-reachable** navigation on 6–6.7″ phones

---

## 1) Material Design 3 Expressive is Mandatory

**Rule:** Do not disable Material 3. Use M3 components everywhere (`NavigationBar`, `FilledButton`, `Card`, `TextField`). Adopt M3 Expressive philosophy: smooth animations, layered depth, dynamic motion.

**Check:**
- No `useMaterial3: false` anywhere
- Bottom navigation is `NavigationBar`, not custom `BottomNavigationBar`
- All buttons use M3 variants: `FilledButton`, `OutlinedButton`, `TextButton`
- Cards use M3 shadows and rounded corners (16dp default)
- Interactive elements have smooth, deliberate animations

**Why:**
Material 3 Expressive was redesigned in 2024–2025 with updated physics for motion, better typography hierarchy, and improved touch feedback. It's the standard for modern Android apps and works well across iOS via Flutter's Material theme.

---

## 2) Dynamic Color (Material You) + Correct Fallback

**Rule:** 
- **Android 12+:** Use system palettes via `dynamic_color` package. The palette adapts to wallpaper and system theme.
- **Android 10–11 & iOS:** Use `ColorScheme.fromSeed(seedColor: _seed)` with AA contrast ratio (4.5:1 for normal text).
- **Always:** No hardcoded `Color(0xFF...)` inside widgets. Use theme roles: `primary`, `secondary`, `error`, `*Container` variants.

**Check:**
- Pixel 8+ (Android 12+): Palette changes when wallpaper changes ✓
- Android 10–11: Stable seed-based colors ✓
- iOS: `ColorScheme.fromSeed` applied correctly ✓
- All colors read from `Theme.of(context).colorScheme` ✓
- AA contrast ratio verified for all text ✓

**Code example:**
```dart
const _seed = Color(0xFF6750A4);

ColorScheme lightScheme = lightDynamic ?? ColorScheme.fromSeed(seedColor: _seed);
ColorScheme darkScheme = darkDynamic ?? ColorScheme.fromSeed(seedColor: _seed, brightness: Brightness.dark);
```

**Color roles to use:**
- `primary` – main actions, focus states
- `secondary` – secondary actions, filters
- `tertiary` – accent color (brand or status)
- `error` – errors, destructive actions
- `*Container` – soft backgrounds for chips, status badges
- `surface` – main background
- `surfaceContainerHighest` – elevated cards, modals
- `outlineVariant` – subtle borders, dividers

**Why:**
Dynamic color creates a cohesive experience where the app's palette matches the user's device theme. It's a marker of modern, quality apps. On older devices, seed-based colors ensure consistent, accessible contrast.

---

## 3) Glanceable-First Home Screen (Bento Grid + Adaptive Layout)

**Rule:** 
- Home screen is a **grid of cards** with quick value: status, progress, one key number, or action.
- Use **bento grid layout** (mixed card sizes: 1×1, 1×2, 2×1, 2×2).
- **≥2 important cards visible without scrolling** (key insight: user grasps "what matters" in 1–2 seconds).
- **Adaptive to device size:** Phone (2 columns), tablet (3–4 columns), foldable (flex layout).
- Cards have **rounded corners (16dp)**, **subtle shadows**, and **no visual clutter**.

**Check:**
- Home visible area shows ≥2 key cards above the fold ✓
- Card grid adapts to device width (use `LayoutBuilder` or `ResponsiveSizer`) ✓
- Each card has one primary action + optional context ✓
- No more than 3–4 cards visible without scroll (encourages focus) ✓
- Grid runs at 60 FPS (use `GridView.builder`) ✓

**Bento grid example:**
```dart
GridView.count(
  crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
  crossAxisSpacing: 12,
  mainAxisSpacing: 12,
  childAspectRatio: 1.5, // tall narrow, or 2.0 for wider
  children: [
    _GlanceCard(...), // status
    _GlanceCard(...), // delivery time
    _GlanceCard(...), // balance
    _GlanceCard(...), // recommendations
  ],
)
```

**Card design:**
- Padding: 16dp inside
- Border radius: 16dp
- Minimum touch target: 48×48dp
- Content: icon (32dp) + title (medium) + subtitle (small) + optional badge
- Background: `surfaceContainerHighest` (light) or `surfaceContainer` (contrast-adjusted for dark)

**Why:**
Glanceable design is the 2025 trend. Users don't want to scroll through lists; they want key information visible at a glance. Bento grids are flexible across screen sizes and create a modern, app-like feel.

---

## 4) Gesture-Based Navigation + Microinteractions

**Rule:**
- **Swipe navigation:** Horizontal swipes for screen transitions, vertical swipes for bottom sheets.
- **Gesture semantics:** Back swipe, dismiss swipe, reveal swipe.
- **Microinteractions:** 120–200 ms animations via `AnimatedContainer`, `AnimatedOpacity`, implicit animations.
- **Haptics:** Use `HapticFeedback.selectionClick()` for:
  - Tab/destination selection
  - Button confirmation
  - Form validation feedback
- **No empty vibrations.** Every haptic has a UI response (color change, scale animation, etc.).

**Check:**
- Back button uses swipe gesture (standard Android) ✓
- Tab changes trigger haptics + visual feedback (color + scale) ✓
- BottomSheet dismissal has haptic feedback ✓
- All animations 120–200 ms, no >300 ms without strong reason ✓
- Manifest includes `<uses-permission android:name="android.permission.VIBRATE"/>` ✓

**Code example:**
```dart
// Haptic + microinteraction on tap
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) {
    setState(() => _pressed = false);
    HapticFeedback.selectionClick(); // haptic feedback
    // navigate or act
  },
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 160),
    curve: Curves.easeOut,
    color: _pressed ? cs.secondaryContainer : cs.surfaceContainerHighest,
    // Transform for scale effect
    transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
  ),
)
```

**Haptic patterns (2025 standard):**
- **Selection click** (`selectionClick`): Tab change, menu item selection → most common
- **Light impact** (`lightImpact`): Error, warning → not common, use sparingly
- **Medium impact** (`mediumImpact`): Confirmation, success → rare
- **Heavy impact** (`heavyImpact`): Critical action → very rare

**Why:**
Gesture-based navigation is now expected, not novel. Haptics are no longer gimmicks—they provide tactile confirmation that an action was registered. Modern phones have precise haptic engines. Microinteractions (small, purposeful animations) reduce cognitive load by providing visual feedback at the exact moment of interaction.

---

## 5) Accessibility: WCAG 2.2 + Semantics (Not Optional)

**Rule:**
- **Touch targets:** All interactive elements ≥48×48dp (48 logical pixels = ~9mm on most phones)
- **Semantics:** Wrap custom elements with `Semantics`, set `label`, `role`, `state`
- **Contrast:** Text AA (4.5:1 normal, 3:1 large) verified with tools
- **Color:** Never rely on color alone to convey info (e.g., error = red + text "Error")
- **Dark mode:** Both light and dark themes tested for contrast ✓
- **Screen readers:** VoiceOver (iOS) and TalkBack (Android) tested on at least one screen

**Check:**
- All buttons, cards, inputs ≥48×48dp ✓
- Custom interactive elements have `Semantics` with `label` ✓
- Text contrast ≥4.5:1 in light mode, ≥4.5:1 in dark mode ✓
- No color-only status indicators (error badge has icon + text) ✓
- Screen reader announces card role and value correctly ✓

**Code example:**
```dart
Semantics(
  button: true,
  label: '${widget.title}. ${widget.subtitle}. Button.',
  enabled: true,
  onTap: () {},
  child: GestureDetector(
    onTap: () {},
    child: Container(
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      // ...
    ),
  ),
)
```

**Dark mode standard (2025):**
- Both light and dark schemes required
- Use `ThemeData(colorScheme: darkScheme)` for dark theme
- Test all content in both modes before release
- No hardcoded colors—all from `ColorScheme`

**Why:**
WCAG 2.2 is now expected by users and regulators. Apps without accessibility support are perceived as low-quality. Semantic annotations ensure screen readers work correctly. Dark mode is no longer a feature—it's an expectation, especially for battery efficiency on OLED screens.

---

## 6) Bottom Navigation: Thumb-Reachable, 2–5 Destinations

**Rule:**
- Use `NavigationBar` (M3) for 2–5 top-level destinations
- **Thumb-reachable:** Bottom navigation positioned in lower third (within one-handed reach on 6–6.7″ phones)
- **Secondary navigation:** Use `BottomSheet` or drawer for filters, settings, less-used actions
- **Clear labels:** Each destination has icon + label (no icon-only unless < 3 destinations)

**Check:**
- Bottom navigation uses M3 `NavigationBar` ✓
- Max 5 destinations (if >5, move to tabs or side menu) ✓
- Bottom edge of navigation ≤20mm from bottom on typical 6.1″ phone ✓
- Labels visible (no hidden labels on scroll) ✓
- Destination icons clear and distinct ✓

**Code example:**
```dart
NavigationBar(
  selectedIndex: _index,
  onDestinationSelected: (i) {
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  },
  destinations: const [
    NavigationDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.explore_outlined),
      selectedIcon: Icon(Icons.explore),
      label: 'Explore',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

**Why:**
Bottom navigation is proven to have higher engagement than top tabs. Users can navigate with one hand. The M3 `NavigationBar` includes haptic feedback by default and scales well across devices.

---

## 7) Responsive & Adaptive Layouts (Phone, Tablet, Foldable)

**Rule:**
- **Phone (< 600dp):** Single column, full-width cards, bottom navigation
- **Tablet (600–840dp):** Two columns, split-view navigation
- **Large (> 840dp & foldable):** Three columns or side navigation rail
- **Foldable:** Flex layout, no fixed assumptions about orientation
- Use `MediaQuery`, `LayoutBuilder`, or responsive packages (`flutter_responsive_screen`)

**Check:**
- Home grid adapts column count based on width ✓
- Navigation rail appears on tablets (side nav instead of bottom) ✓
- Cards scale appropriately (not too wide on tablet) ✓
- No assumed portrait-only orientation ✓
- Foldable device tested (fold seam handled gracefully) ✓

**Code example:**
```dart
LayoutBuilder(
  builder: (context, constraints) {
    int columns = constraints.maxWidth > 840 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
    return GridView.count(
      crossAxisCount: columns,
      childAspectRatio: 1.5,
      children: [...],
    );
  },
)
```

**Foldable support (2025 trend):**
- Don't hardcode screen dimensions
- Use `MediaQuery.of(context).size` + `LayoutBuilder`
- Handle hinge offset (Android provides via platform channel if needed)
- Test on Samsung Galaxy Z Fold, Pixel Fold simulators

**Why:**
Responsive design is no longer optional. Tablets and foldables are common, and users expect apps to adapt. Ignoring large screens is a sign of outdated UI thinking.

---

## 8) Dark Mode: Both Themes Required

**Rule:**
- **Always provide** both light and dark `ThemeData`
- Set `themeMode: ThemeMode.system` (follow device preference)
- Use `ColorScheme.fromSeed(..., brightness: Brightness.dark)` for dark theme
- **Test contrast** in dark mode (≥4.5:1 for text)
- **No color changes for visibility in dark mode alone** (e.g., don't use lighter icon in dark mode if emoji is already visible)

**Check:**
- App respects device dark mode setting ✓
- All text readable in dark mode (≥4.5:1 contrast) ✓
- Images/vectors visible in dark mode (not black on black) ✓
- Status icons (error, success) visible in both modes ✓

**Code example:**
```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: lightScheme,
    useMaterial3: true,
  ),
  darkTheme: ThemeData(
    colorScheme: darkScheme,
    useMaterial3: true,
  ),
  themeMode: ThemeMode.system, // follow device setting
)
```

**Why:**
Dark mode saves battery on OLED screens (each black pixel is off). It's expected, especially for evening usage. Apps without dark mode appear unfinished in 2025.

---

## 9) Smooth Animations: 120–200 ms, Purposeful

**Rule:**
- **Default animation duration:** 150–200 ms (implicit animations)
- **Fast feedback:** 120 ms for button press, tab change
- **Slow reveal:** 250–300 ms only if revealing important info (modal entrance)
- **Curve:** `Curves.easeOut` for responsive feel, `Curves.easeInOut` for deliberate transitions
- **No jank:** Use `.builder` constructors for lists/grids, `AnimatedBuilder` for custom animations

**Check:**
- All animations 120–300 ms (no >500 ms without strong reason) ✓
- Frame rate ≥55 FPS during animations (jank < 1% of frames) ✓
- No heavy work in `build()` method ✓
- Lists use `ListView.builder`, grids use `GridView.builder` ✓

**Code example:**
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 160),
  curve: Curves.easeOut,
  color: _pressed ? cs.secondaryContainer : cs.surfaceContainerHighest,
  child: ...,
)
```

**Performance checklist:**
- Profile app with Flutter DevTools (`flutter run -profile`)
- Monitor frame rate (target: 60 FPS)
- Use `Semantics` sparingly (can impact performance if overused)
- Lazy-load images with `Image.network` + caching

**Why:**
Animations make interfaces feel responsive and alive. But slow, janky animations make apps feel cheap. 2025 standard is smooth 60 FPS. Use animations to guide attention, not to show off.

---

## 10) Navigation: Standard Patterns, Clear Information Architecture

**Rule:**
- **Bottom navigation** for 2–5 main destinations
- **BottomSheet** for secondary options, filters, non-blocking dialogs
- **Explicit back button** (or swipe back on Android)
- **Deep linking:** Support direct URLs to core features
- **No hidden menus:** All main actions visible at first glance

**Check:**
- Clear navigation flow (user knows where they are) ✓
- Back button works as expected ✓
- Deep links tested (can open app from external link) ✓
- Bottom sheet dismissible by swipe or back button ✓
- No more than 2 levels of nested navigation (keep it flat) ✓

**Navigation bar example (already in sections 1–6):**
```dart
NavigationBar(
  selectedIndex: _index,
  onDestinationSelected: (i) {
    HapticFeedback.selectionClick();
    setState(() => _index = i);
  },
  destinations: [
    NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.search_outlined), selectedIcon: Icon(Icons.search), label: 'Search'),
    NavigationDestination(icon: Icon(Icons.person_outlined), selectedIcon: Icon(Icons.person), label: 'Account'),
  ],
)
```

**Why:**
Clear navigation is the foundation of good UX. Users should never feel lost. 2025 standard favors bottom navigation (thumb-reachable) over top menus.

---

## 11) Performance & Optimization

**Rule:**
- **Use builders:** `ListView.builder`, `GridView.builder` for any scrollable list
- **Lazy loading:** Load images on-demand, not all at once
- **Memory:** Dispose controllers, listeners, timers in `dispose()`
- **Build:** No heavy computations in `build()` method
- **Isolates:** For heavy background work (image processing, parsing), use `compute()` or Isolate

**Check:**
- App launches in < 2 seconds ✓
- Scrolling smooth (60 FPS) with large lists ✓
- Memory usage < 200 MB on typical device ✓
- No "jank" spikes in DevTools frame view ✓

**Code example:**
```dart
@override
void dispose() {
  _controller.dispose();
  _listener.removeListener(_onUpdate);
  super.dispose();
}
```

**Why:**
Performance is part of UX. A slow, janky app feels broken, even if it's featureful.

---

## 12) Typography: M3 Standard + Bold Headlines

**Rule:**
- Use M3 text styles: `displayLarge`, `headlineMedium`, `titleLarge`, `bodyMedium`, `labelSmall`
- **Headlines:** Bold (600+), clear visual hierarchy
- **Body text:** Medium (400–500), readable at arm's length (~12–14pt)
- **Line height:** 1.5× font size (standard)
- **Letter spacing:** Tight for headlines, standard for body

**Check:**
- All text uses `Theme.of(context).textTheme.*` ✓
- Headlines bold and prominent ✓
- Body text readable at typical viewing distance ✓
- No hardcoded `TextStyle` (use theme) ✓

**Code example:**
```dart
Text(
  widget.title,
  style: Theme.of(context).textTheme.titleMedium, // not TextStyle(fontSize: 16)
)
```

**Why:**
M3 typography is tested and accessible. Bold headlines make content scannable. Consistency across the app improves perceived polish.

---

## 13) Forms & Input: Clear Labels, Validation Feedback

**Rule:**
- Every `TextField` has a label (not placeholder-only)
- Validation feedback is **immediate** (on blur or keystroke)
- Error messages are **specific** ("Password must be 8+ characters" not "Invalid password")
- Touch targets ≥48dp
- Use `TextInputType` correctly (`.emailAddress`, `.phone`, etc.)

**Check:**
- All inputs have visible labels ✓
- Error messages appear inline ✓
- Keyboard type matches input (email → email keyboard) ✓
- Form submittable only when valid ✓

**Code example:**
```dart
TextField(
  controller: _emailCtrl,
  decoration: InputDecoration(
    labelText: 'Email',
    errorText: _emailError,
    prefixIcon: Icon(Icons.email),
  ),
  keyboardType: TextInputType.emailAddress,
  onChanged: (val) => setState(() => _emailError = _validateEmail(val)),
)
```

**Why:**
Good form UX is invisible. Users shouldn't struggle to enter information. Clear labels and immediate feedback prevent frustration.

---

## 14) Cards & Surfaces: Layered Hierarchy

**Rule:**
- **Surface:** Main background (`ThemeData.scaffoldBackgroundColor`)
- **SurfaceContainer:** Mid-level cards
- **SurfaceContainerHighest:** Elevated cards, important content
- **Rounded corners:** 16dp default for cards, 12dp for smaller elements
- **Shadows:** Use M3 default (`elevation` on M3 Card)
- **Padding:** 16dp inside cards, 12dp between cards

**Check:**
- Visual hierarchy clear (elevated elements stand out) ✓
- Shadows consistent across app ✓
- Card spacing uniform (12–16dp) ✓
- Border radius 12–16dp ✓

**Code example:**
```dart
Card(
  color: Theme.of(context).colorScheme.surfaceContainerHighest,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: ...,
  ),
)
```

**Why:**
Layered surfaces create depth and guide the eye. M3 color roles ensure consistency and adapt to dynamic color.

---

## 15) Icons & Images: Clear, Optimized, Accessible

**Rule:**
- Use Material Icons (bundled in Flutter)
- **Icon size:** 24dp for standard, 32dp for prominent, 16dp for inline
- **Images:** Lazy-load, compress (WebP when possible)
- **Alt text:** Every image has `semanticLabel` or `Semantics`
- **No icon-only buttons** (unless < 3 destinations, then add tooltip)

**Check:**
- All icons from Material Icons set ✓
- Images compressed and cached ✓
- Alt text provided for all images ✓
- Icon sizes consistent ✓

**Code example:**
```dart
Image.network(
  'https://example.com/image.webp',
  semanticLabel: 'Product image: Widget Pro',
  fit: BoxFit.cover,
  cacheWidth: 400, // cache at max display size
)
```

**Why:**
Material Icons are optimized and familiar. Images slow down apps if not cached. Alt text helps screen readers and improves SEO for web.

---

## 16) Motion & Animation Philosophy (2025)

**Core principle:** *Animation guides attention, provides feedback, and creates continuity. Never animate just for beauty.*

**Gesture response (< 120 ms):**
- Button press → color change + scale (98%)
- Tab selection → color change + haptic
- Screen swipe → immediate response (don't delay)

**Navigation transition (200–250 ms):**
- Page transition → smooth fade or slide
- BottomSheet entrance → slide up + fade background
- Modal dismiss → reverse animation

**Value reveal (250–300 ms):**
- Data loading → skeleton → content (smooth transition)
- List item insertion → slide in + fade
- Expansion of accordion → smooth height growth

**Why:**
2025 standard is *purposeful motion*. Every animation serves a function: feedback, guidance, or continuity. Aimless animations make apps feel cheap.

---

## 17) Error Handling & Edge Cases

**Rule:**
- **Network error:** Show clear message + retry button (not just spinner)
- **Empty state:** Illustrative message + CTA (not blank)
- **Loading:** Skeleton or shimmer (not just spinner)
- **Validation:** Inline error, not modal dialog
- **Timeout:** User-friendly message, not technical error code

**Check:**
- Error messages are actionable ✓
- Empty states have CTA ✓
- Loading states are not blank ✓
- No technical jargon in user-facing messages ✓

**Code example:**
```dart
if (data.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inbox_outlined, size: 64),
        const SizedBox(height: 16),
        Text('No items yet', style: theme.textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Tap "Create" to get started', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 16),
        FilledButton(onPressed: _create, child: const Text('Create')),
      ],
    ),
  );
}
```

**Why:**
Error handling is often overlooked. Good error UX prevents user frustration and builds trust.

---

## 18) Analytics & Metrics (Outcome-Based, Not Vanity)

**Rule:**
- Track **ATCT** (Average Time to Core Task): How fast do users complete the primary action?
- Track **CTR** of glanceable cards: Are cards on home screen clicked?
- Track **form abandonment:** Where do users drop off?
- Track **screen reader usage:** Accessibility adoption
- **Ignore:** Page views, session length, DAU (vanity metrics)

**Check:**
- ATCT improved ≥10–20% after UI rollout ✓
- Glanceable card CTR > 15% ✓
- Form completion rate > 80% ✓

**Why:**
Outcome-based metrics show if UI actually improves user experience. Vanity metrics hide problems.

---

## 19) Code Organization & Maintainability

**Rule:**
- **Separation of concerns:** Widgets, business logic, data
- **Naming:** Clear, descriptive (`_GlanceCard` not `_Card1`)
- **Reusability:** Extract common patterns into widgets
- **Comments:** Explain *why*, not *what* (code is obvious, intent is not)
- **Formatting:** Use `dart format`

**Check:**
- No god widgets (> 300 lines) ✓
- Business logic in separate services/providers ✓
- No magic strings/numbers (use constants) ✓
- Consistent naming convention ✓

**Example structure:**
```
lib/
├── main.dart              # App setup, theme
├── screens/
│   ├── home_screen.dart
│   ├── detail_screen.dart
├── widgets/
│   ├── glance_card.dart
│   ├── bottom_navigation.dart
├── services/
│   ├── api_service.dart
│   ├── storage_service.dart
└── models/
    ├── user.dart
    ├── product.dart
```

**Why:**
Clean code is maintainable code. Future developers (including you in 6 months) will thank you.

---

## 20) Release Checklist

- [ ] Material 3 enabled (`useMaterial3: true`)
- [ ] Dynamic color implemented (Android 12+)
- [ ] Dark mode theme tested and accessible
- [ ] Home screen shows ≥2 glanceable cards without scroll
- [ ] Bottom navigation uses M3 `NavigationBar` with haptics
- [ ] All interactive elements ≥48×48dp
- [ ] All custom interactive elements have `Semantics`
- [ ] Text contrast ≥4.5:1 in both light and dark modes
- [ ] Gestures implemented (swipe, tap, long-press with feedback)
- [ ] Microinteractions (animations 120–200 ms) smooth (60 FPS)
- [ ] Haptic feedback on meaningful actions
- [ ] Responsive layout tested on phone, tablet, foldable
- [ ] Images optimized and lazy-loaded
- [ ] Error handling covers network, empty state, timeout
- [ ] Loading states use skeleton or shimmer, not just spinner
- [ ] Accessibility tested with screen reader (VoiceOver/TalkBack)
- [ ] Deep linking works for main screens
- [ ] App performance < 2 sec launch, < 200 MB memory
- [ ] Analytics track ATCT, CTR, form completion
- [ ] Code organized, no god widgets, clear naming

---

## Bonus: Material Design 3 Expressive Glossary

**Glassmorphism:** Transparent, blurred glass-like effect with layered depth. Trending in 2024–2025.

**Neumorphism:** Soft-UI design with subtle shadows and highlights, creating a tactile, embossed look.

**Bento grid:** Mixed-size card layout inspired by Japanese bento boxes. Popular for home screens.

**Haptic feedback:** Tactile vibration in response to user action. Modern phones have precise haptic engines.

**Microinteraction:** Small, purposeful animation (< 300 ms) in response to user input. E.g., button press, tab change.

**Glanceable:** Information instantly recognizable at a glance (< 2 sec), without deep reading or interaction.

**Adaptive UI:** Interface that adjusts layout, components, or content based on device size, orientation, or user context.

**Dark mode:** Dark color scheme for reduced eye strain and battery savings on OLED screens.

**Thumb-reachable:** UI elements positioned in the lower third of the screen for easy one-handed use.

**Dynamic color:** Color palette that adapts to device wallpaper or system theme (Android 12+, Material You).

---

## Further Reading

- [Material Design 3 Guidelines](https://m3.material.io/)
- [Material Design 3 Expressive (Google I/O 2025)](https://www.googleblog.com)
- [Flutter Material Components](https://flutter.dev/docs/development/ui/widgets/material)
- [WCAG 2.2 Accessibility Guidelines](https://www.w3.org/WAI/WCAG22/quickref/)
- [Human Interface Guidelines (iOS)](https://developer.apple.com/design/human-interface-guidelines/)
- [Android Design System](https://developer.android.com/design)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 1.0 | 2025-12-05 | Initial guide based on Material Design 3 Expressive + 2025 trends |

---

**Last updated:** December 5, 2025  
**Maintainer:** Design & Development Team  
**Status:** Active