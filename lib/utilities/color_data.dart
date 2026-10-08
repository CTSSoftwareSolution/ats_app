import 'dart:ui';

// ATS colour tokens. See docs/design_system.md for when to use each one.
//
// Palette: Deep Indigo. [appColor] (#3F51B5) is the brand / primary colour
// (app bars, primary actions, selected states); [secondaryColor] (#5C6BC0)
// is the supporting indigo; [accent] (#7C4DFF) is a violet highlight used
// sparingly on light surfaces, with [accentOnDark] as its tint for indigo /
// dark surfaces. Text is slate ([textPrimary] #263238). Everything else is
// neutral or semantic (pass / fail / warn / info / disabled). Semantic
// colours are unchanged.
//
// The block directly below (up to `background`) is the legacy palette, still
// referenced by older screens. It is mapped onto the current palette so those
// screens match; new UI uses the tokens from "new-manual-flow" onward.

const appColor = Color(0xFF3F51B5);
const appGradientColor = Color(0xFF1A237E);
const stepperInactiveColor = Color(0x4A3F51B5);
const bottomIconColor = Color(0xFF9FA8DA);
const scanTextColor = Color(0xFF37474F);
const cardBackgroundColor = Color(0x143F51B5);
const greenColor = Color(0xFF15803D);
const redColor = Color(0xFFC62828);
const whiteColor = Color(0xFFFFFFFF);
const indicatorContainerColor = Color(0x4DFFFFFF);
const indicatorColor = Color(0x8AFFFFFF);
const blackColor = Color(0xFF263238);
const greyLightColor = Color(0xFFD9DCEC);
const greyColor = Color(0xFF5F7480);
const mediaPickerColor = Color(0xFFE8EAF6);
const cameraBackConColor = Color(0x4FD9DCEC);
const textFieldColor = Color(0xFFE8EAF6);
const background = Color(0xFFFAFAFF);

// new-manual-flow

// Brand (Deep Indigo).
// [primaryDark]    deepest indigo: shadows, inverse surfaces, dark panels.
// [appColor]       primary: app bars, primary buttons, FAB, focus, selection.
// [secondaryColor] supporting indigo (4.9:1 on white, white text is AA):
//                  secondary actions, progress, section accents.
// [secondaryDark]  secondary text and icons on light surfaces. Same as
//                  [secondaryColor], which is already readable on white.
// [secondaryLight] tinted fill behind secondary content (chips, banners).
// [primaryLight]   muted violet for section icons / labels beside
//                  [appColor] and [secondaryColor] (5.2:1 on white).
const primaryDark = Color(0xFF1A237E);
const secondaryColor = Color(0xFF5C6BC0);
const secondaryDark = secondaryColor;
const secondaryLight = Color(0xFFE8EAF6);
const primaryLight = Color(0xFF7E57C2);

// Backgrounds
const bg = Color(0xFFFAFAFF);
const surface = Color(0xFFFFFFFF);
const surface2 = Color(0xFFE8EAF6);

// Borders
const border = Color(0xFFE0E3F0);
const borderDark = Color(0xFFB4BADB);

// Semantic (unchanged: Pass / Fail / Pending)
const pass = Color(0xFF15803D);
const passLight = Color(0xFFE7F6EC);
const passBorder = Color(0xFFBFE5CC);
const fail = Color(0xFFC62828);
const failLight = Color(0xFFFDECEC);
const failBorder = Color(0xFFF5C6C6);
const warn = Color(0xFFB45309);
const warnLight = Color(0xFFFEF4E2);
const warnBorder = Color(0xFFF6D9A8);
// Status text and icons on dark or media surfaces (indigo panels, photo
// overlays), where [pass] / [warn] are too dark to read.
const passOnDark = Color(0xFF4ADE80);
const warnOnDark = Color(0xFFFBBF24);
// Information and in-progress states (uploading, info banners): the
// secondary indigo, distinct from Pass / Fail / Pending.
const infoColor = Color(0xFF5C6BC0);
const infoLight = Color(0xFFE8EAF6);
const na = Color(0xFF5F7480);
const naLight = Color(0xFFF1F2F8);

// Disabled controls: foreground (text / icons) and fill.
const disabledFg = Color(0xFFA6ABC4);
const disabledBg = Color(0xFFEEEFF6);

// Text
const textPrimary = Color(0xFF263238);
const textSecondary = Color(0xFF546E7A);
const textMuted = Color(0xFF687D88);
const textWhite = Color(0xFFFFFFFF);
const textWhiteSub = Color(0xFFD1D5F0);

// Accent: violet (#7C4DFF, 4.8:1 on white) for sparing highlights on light
// surfaces (theme `tertiary`). On indigo / dark surfaces (tab indicators,
// snackbar actions) use [accentOnDark]. [accentLight] is the tinted fill for
// selected states on light surfaces.
const accent = Color(0xFF7C4DFF);
const accentOnDark = Color(0xFFB388FF);
const accentLight = Color(0xFFE8EAF6);
const accentContainer = Color(0xFFEDE7FF);

// Overlay behind dialogs and bottom sheets (deep indigo at 45%).
const scrim = Color(0x731A237E);

// Media surfaces: camera preview and full-screen image / video viewers.
const mediaBg = Color(0xFF000000);

// Translucent backing for controls and captions laid over a photo or video
// (black at 55%), so white text stays readable on any image.
const mediaScrim = Color(0x8C000000);

// Loading skeletons (shimmer base and sweep).
const shimmerBase = Color(0xFFE6E8F3);
const shimmerHighlight = Color(0xFFF5F6FC);
